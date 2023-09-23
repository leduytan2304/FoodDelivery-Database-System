USE QL_DH_GH
GO
drop proc sp_DT_ThemChiNhanh
CREATE PROC sp_DT_ThemChiNhanh 
	@IDChiNhanh Char(5),
	@IDDoiTac Char(5),
	@DiaChi Nvarchar(100),
	@TenChiNhanh Nvarchar(50),
	@TGHD time,
	@TTCH Nvarchar(30)
AS

BEGIN TRAN
	BEGIN TRY
	--Kiểm tra địa chỉ có trùng hay không
	IF(EXISTS(SELECT * FROM CHINHANH WHERE IDDoiTac = @IDDoiTac AND DIACHI = @diachi))
			begin
			rollback tran
			RETURN  0
			end

	-- Kiểm tra mã chi nhánh có trùng hay không
	IF(EXISTS(SELECT * FROM CHINHANH WHERE IDCHINHANH = @IDchinhanh and IDDoiTac = @IDDoiTac))
			begin
			rollback tran
			RETURN  0
			end
	END TRY
	BEGIN CATCH
		PRINT N'LỖI HỆ THỐNG'
		ROLLBACK TRAN
		RETURN 0
	END CATCH
	
	INSERT INTO CHINHANH
	VALUES
		(@IDChiNhanh,@IDDoiTac,@DiaChi,@TenChiNhanh,@TGHD,@TTCH)

	UPDATE DOITAC
	SET SLChiNhanh = SLChiNhanh + 1
	WHERE IDDoiTac = @IDDoiTac
	WAITFOR DELAY '00:00:20'
	IF @IDChiNhanh = NULL OR @IDDoiTac = NULL OR @DiaChi = NULL OR @TenChiNhanh = NULL OR @TGHD = NULL OR @TTCH = NULL 
				BEGIN
               PRINT N'Không thể thêm chi nhánh'
               ROLLBACK tran
               RETURN -1
	END

COMMIT TRAN
	return 1
GO

CREATE PROC Sp_KH_XEMSP
	@IDDOITAC CHAR(5)
AS
BEGIN TRAN
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	BEGIN TRY
		IF NOT EXISTS (SELECT * FROM DOITAC WHERE IDDoiTac = @IDDOITAC)
		BEGIN
			PRINT N'ĐỐI TÁC KHÔNG TỒN TẠI'
		END
	END TRY
	BEGIN CATCH
		PRINT N'LỖI HỆ THỐNG'
		ROLLBACK TRAN
	END CATCH
	SELECT  M.TENMON, QLTD.TinhTrangMon, M.GiaMon, CN.DIACHI, M.IDMon 
                FROM MON M, QLTHUCDON QLTD, CHINHANH CN
                WHERE QLTD.IDChiNhanh = CN.IDCHINHANH
                AND QLTD.IDDoiTac = CN.IDDoiTac
                AND QLTD.IDDoiTac = @IDDOITAC AND QLTD.IDMon = M.IDMon
COMMIT TRAN
GO