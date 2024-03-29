SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[ACTUORDCOMPRA] ON [dbo].[DSCOMCOMD]
WITH EXECUTE AS CALLER
FOR INSERT
AS
DECLARE @COMPRA VARCHAR(10);
DECLARE @articulo varchar(15);
DECLARE @recibido float; --Sinonimo de double precision
DECLARE @tipo int
BEGIN
  SELECT @compra = cmcodigo, @articulo = CMARTICULO, @recibido = cmcantidad, 
  @tipo = cmtipo FROM inserted

  IF (@tipo = 2 )
    SET @recibido = (@recibido * -1);
  
  IF (NOT @compra IS NULL)
  BEGIN
  	UPDATE DSCOMORDCOMD SET omrecibido = (omrecibido + @recibido)
    	WHERE (omcodigo = @compra) AND (OMARTICULO = @articulo) and (OMTIPO = @tipo)
	END
END

/* CREATE TRIGGER ACTUORDCOMPRA FOR DSCOMCOMD
ACTIVE AFTER INSERT
POSITION 1
AS
DECLARE VARIABLE COMPRA VARCHAR(10);
BEGIN
  if (new.CMTIPO = 1) then
  begin
    select codoc from DScomcome where cocodigo = new.cmCODIGO into :compra;
    if (not compra is null) then
    begin
         update DSCOMORDCOMD
            set omrecibido = omrecibido + new.cmcantidad
         where omcodigo = :compra and new.cmARTICULO = omarticulo;
    end
  end
END */
GO