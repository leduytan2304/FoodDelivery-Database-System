--Xem danh sách món trong thực đơn
GO
CREATE PROC Sp_KH_XEMTD
	@IDDoiTac Char(5),
	@IDChiNhanh Char(5)
AS
BEGIN TRAN
	BEGIN TRY

	IF NOT EXISTS(SELECT * FROM CHINHANH CN WHERE CN.IDDoiTac = @IDDoiTac AND CN.IDChiNhanh = @IDChiNhanh )
	BEGIN
		PRINT N'Chi nhánh hoặc đối tác không tồn tại'
		ROLLBACK TRAN
		RETURN 0
	END
	WAITFOR DELAY '00:00:20'
	END TRY
	BEGIN CATCH
		PRINT N'LỖI HỆ THỐNG'
		ROLLBACK TRAN
		RETURN 0
	END CATCH
    SELECT * FROM QLTHUCDON QLTD WHERE QLTD.IDDoitac = @IDDoitac AND QLTD.IDChiNhanh = @IDChiNhanh
COMMIT TRAN
	return 1
go

--Xoá món trong thực đơn
GO
CREATE PROC Sp_DT_XOAMONTD
    @IDMon Char(5),
	@IDDoiTac Char(5),
	@IDChiNhanh Char(5)
AS
BEGIN TRAN
	BEGIN TRY

	IF NOT EXISTS(SELECT * FROM CHINHANH CN WHERE CN.IDDoiTac = @IDDoiTac AND CN.IDChiNhanh = @IDChiNhanh )
	BEGIN
		PRINT N'Chi nhánh hoặc đối tác không tồn tại'
		ROLLBACK TRAN
		RETURN 0
	END

    IF NOT EXISTS(SELECT * FROM Mon WHERE Mon.IDMon = @IDMon)
	BEGIN
		PRINT N'Món ăn không tồn tại'
		ROLLBACK TRAN
		RETURN 0
	END

    IF NOT EXISTS(SELECT * FROM QLThucDon WHERE QLThucDon.IDMon = @IDMon)
	BEGIN
		PRINT N'Món ăn không có trong thực đơn'
		ROLLBACK TRAN
		RETURN 0
	END

	END TRY
	BEGIN CATCH
		PRINT N'LỖI HỆ THỐNG'
		ROLLBACK TRAN
		RETURN 0
	END CATCH
    DELETE FROM QLThucDon WHERE IDMon=@IDMon AND IDChiNhanh=@IDChiNhanh AND IDDoiTac = @IDDoiTac
COMMIT TRAN
	PRINT N'Xoá món trong thực đơn thành công'
	return 1
go