/*
================================================================================
檔案代號:aba_file
檔案名稱:会计凭证单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table aba_file
(
aba00       varchar2(5) NOT NULL,    /*帐套                                   */
aba01       varchar2(20) NOT NULL,   /*凭证编号                               */
aba02       date,                    /*凭证日期                               */
aba03       number(5),               /*会计年度                               */
aba04       number(5),               /*期间                                   */
aba05       date,                    /*录入日期                               */
aba06       varchar2(2) NOT NULL,    /*来源码                                 */
                                     /*Source Code                              GL:General Voucher Input aglt110                   RV:Reverse Voucher Input aglt120                    AC:Accrued Voucher Input aglt130                    RA:Accrued Adjustment                                  FA: Fixed Asset                                      FC: Fixed Amount                                    FP: Fixed Ratio                                        VP: Variable Ratio                               NM: Note Voucher Input                                      AP: A/P Voucher Input                           AR: A/R Voucher Input                              CE: Generate This Term Income statement Voucher By Computer                                            LC: A/P Foreign Purchase (99/05/27 add)            GF: Prepayment (99/05/27 add)                   AD: Audit Adjustment*/
aba07       varchar2(30),            /*参考号码                               */
aba08       number(20,6),            /*借方总金额                             */
aba09       number(20,6),            /*贷方总金额                             */
aba10       varchar2(24),            /*收支科目                               */
aba11       number(10),              /*总号                                   */
aba12       varchar2(1),             /*是否分摊                               */
aba13       number(20,6),            /*被分摊金额                             */
aba14       varchar2(1),             /*分摊方式                               */
aba15       varchar2(10),            /*分摊编号                               */
aba16       varchar2(5),             /*抛转帐套                               */
aba17       varchar2(20),            /*抛转凭证编号                           */
aba18       varchar2(10),            /*版本                                   */
aba19       varchar2(1),             /*确认码                                 */
aba20       varchar2(1),             /*状态码                                 */
aba21       varchar2(3),             /*附件张数                               */
aba22       varchar2(1),             /*No Use                                 */
aba23       varchar2(1),             /*No Use                                 */
abamksg     varchar2(1),             /*签核否                                 */
abasign     varchar2(4),             /*签核等级                               */
abadays     number(5),               /*签核完成天数                           */
abaprit     number(5),               /*签核优先等级                           */
abasmax     number(5),               /*应签等级                               */
abasseq     number(5),               /*已签等级                               */
abaprno     number(5),               /*打印次数                               */
abapost     varchar2(1),             /*过帐码                                 */
abaacti     varchar2(1),             /*资料有效码                             */
abauser     varchar2(10),            /*资料所有者                             */
abagrup     varchar2(10),            /*资料所有群                             */
abamodu     varchar2(10),            /*资料更改者                             */
abadate     date,                    /*最近更改日                             */
aba24       varchar2(10),            /*申请人                                 */
aba31       varchar2(20),            /*结算方式                               */
aba32       varchar2(20),            /*票据类型                               */
aba33       varchar2(20),            /*票据号                                 */
aba34       date,                    /*票据日期                               */
aba35       varchar2(1),             /*出纳否                                 */
aba36       varchar2(10),            /*出纳人员                               */
aba37       varchar2(10),            /*审核人员                               */
aba38       varchar2(10),            /*过帐人员                               */
abaud01     varchar2(255),           /*自订字段-Textedit                      */
abaud02     varchar2(40),            /*自订字段-文字                          */
abaud03     varchar2(40),            /*自订字段-文字                          */
abaud04     varchar2(40),            /*自订字段-文字                          */
abaud05     varchar2(40),            /*自订字段-文字                          */
abaud06     varchar2(40),            /*自订字段-文字                          */
abaud07     number(15,3),            /*自订字段-数值                          */
abaud08     number(15,3),            /*自订字段-数值                          */
abaud09     number(15,3),            /*自订字段-数值                          */
abaud10     number(10),              /*自订字段-整数                          */
abaud11     number(10),              /*自订字段-整数                          */
abaud12     number(10),              /*自订字段-整数                          */
abaud13     date,                    /*自订字段-日期                          */
abaud14     date,                    /*自订字段-日期                          */
abaud15     date,                    /*自订字段-日期                          */
abalegal    varchar2(10) NOT NULL,   /*所属法人                               */
abaoriu     varchar2(10),            /*资料建立者                             */
abaorig     varchar2(10)             /*资料建立部门                           */
);

create        index aba_02 on aba_file (aba02);
create        index aba_03 on aba_file (aba11);
alter table aba_file add  constraint aba_pk primary key  (aba01,aba00) enable validate;
grant select on aba_file to tiptopgp;
grant update on aba_file to tiptopgp;
grant delete on aba_file to tiptopgp;
grant insert on aba_file to tiptopgp;
grant index on aba_file to public;
grant select on aba_file to ods;
