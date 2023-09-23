USE QL_DH_GH
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

CREATE PROC Sp_DT_THEMSP
	@IDMON CHAR(5),
	@TENMON nvarCHAR(50),
	@GiaMon money, 
	@IDDoiTac CHAR(5),
	@IDChiNhanh CHAR(5),
	@MieuTaMon Nvarchar(50),
	@TinhTrangMon Nvarchar(50),
	@TuyChonChoMon Nvarchar(30)
AS
BEGIN TRAN
	BEGIN TRY
		IF NOT EXISTS(SELECT*
				FROM DOITAC DT, CHINHANH CN, MON M
				WHERE DT.IDDoiTac=@IDDoiTac AND CN.IDChiNhanh=@IDChiNhanh AND m.TenMon=@TENMON)
			BEGIN
				PRINT N'MON DA TON TAI'
				ROLLBACK TRAN
				RETURN 1
			END 

		IF NOT EXISTS(SELECT*
				FROM DOITAC DT
				WHERE DT.IDDoiTac=@IDDoiTac)
			BEGIN
				PRINT N'DOI TAC KHONG TON TAI'
				ROLLBACK TRAN
				RETURN 1
			END
	END TRY
	BEGIN CATCH
		PRINT N'LỖI HỆ THỐNG'
		ROLLBACK TRAN
		RETURN 1
	END CATCH
	INSERT MON(IDMon,TenMon,Rating,GiaMon) VALUES (@IDMON,@TENMON,0,@GiaMon)
	INSERT QLTHUCDON(IDDoiTac,IDMon,IDChiNhanh,MieuTaMon,TinhTrangMon,TuyChonChoMon) VALUES (@IDDoiTac,@IDMON,@IDChiNhanh,@MieuTaMon,@TinhTrangMon,@TuyChonChoMon)
	IF @IDDoiTac = '' OR @IDMon = '' OR @IDChiNhanh = '' OR @MieuTaMon = '' OR
@TinhTrangMon = '' OR @TuyChonChoMon = '' 
BEGIN
	delete MON where @IDMon=idmon and @TENMON=tenmon and @GiaMon=giamon
	delete QLTHUCDON where @IDMon=idmon and @IDChiNhanh=IDChiNhanh and @MieuTaMon=MieuTaMon and @TinhTrangMon=TinhTrangMon and @TuyChonChoMon=TuyChonChoMon
	RETURN 1
END

	COMMIT TRAN
GO