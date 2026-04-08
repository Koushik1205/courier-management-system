@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child Interface View – Shipment Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZCIT_SHPI_I_22AM022
  as select from zcit_shpi22am022
  association to parent ZCIT_SHIP_I_22AM022 as _ShipHeader
    on $projection.ShipmentId = _ShipHeader.ShipmentId
{
  key shipmentid           as ShipmentId,
  key itemnumber           as ItemNumber,
  packagedescription       as PackageDescription,
  packagetype              as PackageType,
  @Semantics.quantity.unitOfMeasure: 'WeightUnit'
  weight                   as Weight,
  weightunit               as WeightUnit,
  @Semantics.quantity.unitOfMeasure: 'DimensionUnit'
  volume                   as Volume,
  dimensionunit            as DimensionUnit,
  trackingstatus           as TrackingStatus,
  @Semantics.user.createdBy: true
  local_created_by         as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at         as LocalCreatedAt,
  @Semantics.user.lastChangedBy: true
  local_last_changed_by    as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at    as LocalLastChangedAt,
 
  /* Associations */
  _ShipHeader
}
