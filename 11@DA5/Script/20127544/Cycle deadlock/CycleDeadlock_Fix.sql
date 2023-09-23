USE QL_DH_GH
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
	SET TRANSACTION ISOLATION LEVEL Repeatable read

	BEGIN TRY
	--Ki?m tra ??a ch? có trùng hay không
	IF(EXISTS(SELECT * FROM CHINHANH WHERE IDDoiTac = @IDDoiTac AND DIACHI = @diachi))
			begin
			rollback tran
			RETURN  -1
			end

	-- Ki?m tra mã chi nhánh có trùng hay không
	IF(EXISTS(SELECT * FROM CHINHANH WHERE IDCHINHANH = @IDchinhanh and IDDoiTac = @IDDoiTac))
			begin
			rollback tran
			RETURN  -1
			end
	END TRY
	BEGIN CATCH
		PRINT N'L?I H? TH?NG'
		ROLLBACK TRAN
		RETURN -1
	END CATCH
	INSERT INTO CHINHANH WITH (ROWLOCK)
	VALUES
		(@IDChiNhanh,@IDDoiTac,@DiaChi,@TenChiNhanh,@TGHD,@TTCH)
	WAITFOR DELAY '0:0:05'
	UPDATE DOITAC WITH (ROWLOCK)
	SET SLChiNhanh = SLChiNhanh + 1
	WHERE IDDoiTac = @IDDoiTac
COMMIT TRAN
	return 1
GO

CREATE PROC sp_ThemDoiTac
	@IDDoiTac Char(5),
	@IDKhuVuc Char(5),
	@EmailDT Nvarchar(50),
	@TenQuan Nvarchar(30),
	@NguoiDaiDien Nvarchar(30),
	@SLDonHang int,
	@DCKinhDoanh Nvarchar(100),
	@SDTDT Char(12),
	@MaSoThue Char(5),
	@SoTaiKhoanDT Char(20),
	@NganHang nvarchar(100),

	@IDChiNhanh Char(5),
	@DiaChi Nvarchar(100),
	@TenChiNhanh Nvarchar(50),
	@TGHD Time,
	@TTCH Nvarchar(30)
AS
BEGIN TRAN
SET TRANSACTION ISOLATION LEVEL Repeatable read
	BEGIN TRY
	IF(EXISTS(SELECT * 
		FROM DOITAC DT
		WHERE DT.IDDoiTac=@IDDoiTac or dt.MaSoThue=@MaSoThue or dt.NguoiDaiDien=@NguoiDaiDien ))
			begin
			rollback tran
			RETURN  1
			end
	WAITFOR DELAY '0:0:05'
	END TRY
	BEGIN CATCH
		PRINT N'L?I H? TH?NG'
		ROLLBACK TRAN
		RETURN 1
	END CATCH
	
	INSERT INTO DOITAC WITH (ROWLOCK)
	VALUES
		(@IDDoiTac, @IDKhuVuc, @EmailDT, @TenQuan, @NguoiDaiDien, 1, @SLDonHang, @DCKinhDoanh, @SDTDT, @MaSoThue, @SoTaiKhoanDT, @NganHang)
	EXEC sp_DT_ThemChiNhanh @IDChiNhanh,@IDDoiTac, @DiaChi,@TenChiNhanh,@TGHD,@TTCH
COMMIT TRAN
return 0
GO


