USE QL_DH_GH
GO
CREATE PROC sp_KH_XemDSChiNhanh @IDDoiTac char(5)
AS
BEGIN TRAN
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ

	BEGIN TRY
	if not exists(select*
	from CHINHANH cn
	where cn.IDDoiTac=@IDDoiTac)
	BEGIN
		begin
			rollback tran
			RETURN  -1
			end
	END
	WAITFOR DELAY '0:0:05'
	END TRY
	BEGIN CATCH
			PRINT N'LỖI HỆ THỐNG'
			ROLLBACK TRAN
			RETURN 0
	END CATCH
	SELECT CN.IDChiNhanh,CN.IDDoiTac,CN.TenChiNhanh,CN.DiaChi,CN.TGHD,CN.TTCH
	FROM CHINHANH CN
	where cn.IDDoiTac=@IDDoiTac
COMMIT TRAN
return 1
GO

CREATE PROC sp_DT_ThemChiNhanh 
	@IDChiNhanh Char(5),
	@IDDoiTac Char(5),
	@DiaChi Nvarchar(100),
	@TenChiNhanh Nvarchar(50),
	@TGHD time,
	@TTCH Nvarchar(30)
AS

BEGIN TRAN
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ
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
COMMIT TRAN
	return 1
GO