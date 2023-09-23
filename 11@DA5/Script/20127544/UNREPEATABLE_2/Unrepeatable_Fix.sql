USE QL_DH_GH
GO
CREATE PROC sp_KH_XemDSChiNhanh @IDDoiTac char(5)
AS
BEGIN TRAN
SET TRANSACTION ISOLATION LEVEL Repeatable read
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
	WAITFOR DELAY '00:00:20'
	END TRY
	BEGIN CATCH
			PRINT N'L?I H? TH?NG'
			ROLLBACK TRAN
			RETURN 0
	END CATCH
	SELECT CN.IDChiNhanh,CN.IDDoiTac,CN.TenChiNhanh,CN.DiaChi,CN.TGHD,CN.TTCH
	FROM CHINHANH CN
	where cn.IDDoiTac=@IDDoiTac
COMMIT TRAN
return 1
GO

CREATE PROC sp_XoaChiNhanh @IDChiNhanh char(5),@IDDoiTac char(5)
AS
BEGIN TRAN
	BEGIN TRY
	if not exists(select*
	from CHINHANH CN
	where cn.IDDoiTac=@IDDoiTac and cn.IDChiNhanh=@IDChiNhanh)
	BEGIN
		begin
			rollback tran
			RETURN  -1
			end
	END
	END TRY
	BEGIN CATCH
			PRINT N'L?I H? TH?NG'
			ROLLBACK TRAN
			RETURN 0
	END CATCH
	delete CHINHANH where IDDoiTac=@IDDoiTac and IDChiNhanh=@IDChiNhanh
COMMIT TRAN
return 1
GO