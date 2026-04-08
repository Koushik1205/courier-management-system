@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header Consumption View – Courier Tracking'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZCIT_SHIP_C_22AM022
  provider contract transactional_query
  as projection on ZCIT_SHIP_I_22AM022
{
  key ShipmentId,
  CustomerId,
  CustomerName,
  ShipmentDate,
  ExpectedDelivery,
  @Search.defaultSearchElement: true
  ShipmentStatus,
  OriginLocation,
  DestinationLocation,
  CarrierName,
  @Semantics.amount.currencyCode: 'Currency'
  TotalCost,
  Currency,
  LocalCreatedBy,
  LocalCreatedAt,
  LocalLastChangedBy,
  LocalLastChangedAt,
 
  /* Associations */
  _ShipItem : redirected to composition child ZCIT_SHPI_C_22AM022
}
