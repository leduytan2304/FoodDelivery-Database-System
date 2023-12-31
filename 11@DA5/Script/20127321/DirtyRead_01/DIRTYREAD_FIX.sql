USE QL_DH_GH
GO


USE QL_DH_GH
GO
CREATE PROCEDURE DT_CAPNHATTRANGTHAIDONHANG_DH
@IDDonHang varchar(20), 
@TrangThaiDonHang nvarchar(50)
AS
BEGIN TRANSACTION 
	
		BEGIN TRY
		IF NOT EXISTS ( SELECT IDDonHang FROM DONHANG WHERE IDDonHang=@IDDonHang)
			BEGIN
				PRINT N'Đơn hàng không tồn tại'
				ROLLBACK TRANSACTION
				RETURN 1 
			END
			
		END TRY
		BEGIN CATCH
			PRINT N'Lỗi hệ thống'
			ROLLBACK TRANSACTION
			RETURN 1
		END CATCH
			SELECT TrangThaiDonHang FROM DONHANG WHERE IDDonHang = @IDDonHang
			UPDATE DONHANG SET TrangThaiDonHang = @TrangThaiDonHang WHERE IDDonHang = @IDDonHang
			-- Waiting for system's update--
			WAITFOR DELAY '0:0:10'
			COMMIT TRANSACTION
			RETURN 0	
GO	

CREATE PROC KH_XEMDONHANG_DH
 @IDDonHang varchar(20)
 AS 
BEGIN TRANSACTION
	--SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED--
	BEGIN TRY
		IF NOT EXISTS ( SELECT IDDonHang FROM DONHANG WHERE IDDonHang=@IDDonHang)
			BEGIN
				PRINT N'Đơn hàng không tồn tại'
				ROLLBACK TRANSACTION
				RETURN 1 
			END
		SELECT * FROM DONHANG WHERE IDDonHang=@IDDonHang
		END TRY
		BEGIN CATCH
			PRINT N'Lỗi hệ thống'
			ROLLBACK TRANSACTION
			RETURN 1
		END CATCH
		COMMIT TRANSACTION
		RETURN 0
GO