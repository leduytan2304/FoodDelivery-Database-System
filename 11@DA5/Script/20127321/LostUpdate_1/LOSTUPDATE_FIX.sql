use QL_DH_GH
go




--Duyệt hợp đồng
GO
CREATE PROC SP_DUYETHOPDONG1
        @MSHD CHAR(5)
AS
BEGIN TRAN
	BEGIN TRY
		IF NOT EXISTS(SELECT MaSoHopDong FROM HOPDONG HD WHERE HD.MaSoHopDong = @MSHD)
		BEGIN
			PRINT N'Hợp đồng không tồn tại'
			ROLLBACK TRAN
			RETURN 1
		END
		WAITFOR DELAY '0:0:10'
		IF (SELECT TrangThaiDuyet FROM HOPDONG WITH (XLOCK) WHERE @MSHD = MaSoHopDong) !='N'
			BEGIN
				UPDATE HOPDONG
				SET TrangThaiDuyet = 'Y'
				WHERE  MaSoHopDong = @MSHD
				PRINT N'Hợp đồng được duyệt'
				COMMIT TRAN
				RETURN 0
			END
	END TRY
	BEGIN CATCH
		PRINT N'LỖI HỆ THỐNG'
		ROLLBACK TRAN
		RETURN 1
	END CATCH




--EXEC SP_DUYETHOPDONG1  'HD002'

--Không duyệt hợp đồng
GO
CREATE PROC SP_DUYETHOPDONG2
        @MSHD CHAR(5)
AS
BEGIN TRAN
	BEGIN TRY
		IF NOT EXISTS(SELECT MaSoHopDong FROM HOPDONG HD WHERE HD.MaSoHopDong = @MSHD)
		BEGIN
			PRINT N'Hợp đồng không tồn tại'
			ROLLBACK TRAN
			RETURN 1
		END
		IF (SELECT TrangThaiDuyet FROM HOPDONG WHERE @MSHD = MaSoHopDong) !='Y'
		BEGIN
				UPDATE HOPDONG
				SET TrangThaiDuyet = 'N'
				WHERE  MaSoHopDong = @MSHD
				PRINT N'Hợp đồng khong được duyệt'
				COMMIT TRAN
				RETURN 0
			END

	END TRY
	BEGIN CATCH
		PRINT N'LỖI HỆ THỐNG'
		ROLLBACK TRAN
		RETURN 1
	END CATCH

go
