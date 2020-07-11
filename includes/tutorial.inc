// MACROS
#define function%0(%1) forward %0(%1); public %0(%1)
#define HOLDING(%0) ((newkeys & (%0)) == (%0))
#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define RELEASED(%0) (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

// DEFINES
#define FLOAT_INFINITY	(Float:0x7F800000)
#define MAX_PASS_LEN	65
#define SALT_LEN		13

// ENUMERADORES
enum //Dialogs
{
	DIALOG_LOGIN,
	DIALOG_REGISTRO,
	DIALOG_ADMINS,
	DIALOG_INFOADMIN,
	DIALOG_BAN
};