// From Page 10 of the ESCL Manual

ESPservice MathService
{
	ESPmethod AddThis(AddThisRequest, AddThisResponse);
}; 

ESPrequest AddThisRequest
{
	int FirstNumber;
	int SecondNumber;
};

ESPresponse AddThisResponse
{
	int Answer;
};