@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Interface View – Shipment Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCIT_SHIP_I_22AM022
  as select from zcit_ship22am022 as shipHeader
  composition [0..*] of ZCIT_SHPI_I_22AM022 as _ShipItem
{
  key shipmentid           as ShipmentId,
  customerid               as CustomerId,
  customername             as CustomerName,
  shipmentdate             as ShipmentDate,
  expecteddelivery         as ExpectedDelivery,
  shipmentstatus           as ShipmentStatus,
  originlocation           as OriginLocation,
  destinationlocation      as DestinationLocation,
  carriername              as CarrierName,
  @Semantics.amount.currencyCode: 'Currency'
  totalcost                as TotalCost,
  currency                 as Currency,
  @Semantics.user.createdBy: true
  local_created_by         as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at         as LocalCreatedAt,
  @Semantics.user.lastChangedBy: true
  local_last_changed_by    as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at    as LocalLastChangedAt,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed_at          as LastChangedAt,

  /* Associations */
  _ShipItem
}
