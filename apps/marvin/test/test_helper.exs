ExUnit.start()

Mox.defmock(USGSWaterservicesAPIClientMock, for: Marvin.USGSWaterservicesAPI.APIClientBehaviour)
Mox.defmock(HTTPMock, for: HTTPoison.Base)