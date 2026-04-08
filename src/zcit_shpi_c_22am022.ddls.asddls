@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Item Consumption View – Shipment Items'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZCIT_SHPI_C_22AM022
  as projection on ZCIT_SHPI_I_22AM022
{
  key ShipmentId,
  key ItemNumber,
  @Search.defaultSearchElement: true
  PackageDescription,
  PackageType,
  @Semantics.quantity.unitOfMeasure: 'WeightUnit'
  Weight,
  WeightUnit,
  @Semantics.quantity.unitOfMeasure: 'DimensionUnit'
  Volume,
  DimensionUnit,
  TrackingStatus,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
 
  /* Associations */
  _ShipHeader : redirected to parent ZCIT_SHIP_C_22AM022
}
