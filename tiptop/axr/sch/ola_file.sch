/*
================================================================================
檔案代號:ola_file
檔案名稱:销售信用状单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ola_file
(
ola01       varchar2(20) NOT NULL,   /*收状单号                               */
                                     /*收狀單號                               */
ola011      number(5),               /*序号                                   */
                                     /*序號                                   */
ola02       date,                    /*收状日                                 */
                                     /*收狀日                                 */
ola03       varchar2(3),             /*类型                                   */
                                     /*類別                                   */
ola04       varchar2(20),            /*L/C No.                                */
ola05       varchar2(10),            /*客户                                   */
                                     /*客戶                                   */
ola06       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
ola07       number(20,10),           /*汇率                                   */
                                     /*匯率       (99/05/12)                  */
ola08       number(13,4),            /*No Use                                 */
ola09       number(20,6) NOT NULL,   /*信用状金额                             */
                                     /*信用狀金額                             */
ola10       number(20,6) NOT NULL,   /*押汇金额                               */
                                     /*押匯金額                               */
ola11       varchar2(1),             /*1.内销 2.外销                          */
                                     /*1.內銷 2.外銷                          */
ola12       date,                    /*结案日期                               */
                                     /*結案日期                               */
ola13       number(5),               /*押汇日数                               */
                                     /*押匯日數                               */
ola14       date,                    /*有效日期                               */
ola15       varchar2(6),             /*收款条件                               */
                                     /*收款條件                               */
ola16       varchar2(1),             /*付款人是否为银行                       */
                                     /*付款人是否為銀行(Y/N)                  */
ola17       varchar2(1),             /*可否备妥押汇文件                       */
                                     /*可否備妥押匯文件(Y/N)                  */
ola18       varchar2(1),             /*特殊条款可接受否                       */
                                     /*特殊條款可接受否(Y/N)                  */
ola19       varchar2(1),             /*营业部结论                             */
                                     /*營業部結論 1.接受 2.不接受 3.修改L/C   */
ola20       varchar2(1),             /*进出口部结论                           */
                                     /*進出口部結論 1.接受 2.不接受 3.修改L/C */
ola21       varchar2(20),            /*开状银行                               */
                                     /*開狀銀行                               */
ola22       varchar2(20),            /*通知银行                               */
                                     /*通知銀行                               */
ola23       varchar2(20),            /*押汇银行                               */
                                     /*押匯銀行                               */
ola24       date,                    /*开状日                                 */
                                     /*開狀日                                 */
ola25       date,                    /*最后装船日                             */
                                     /*最後裝船日                             */
ola26       date,                    /*最后押汇日                             */
                                     /*最後押匯日                             */
ola271      varchar2(255),           /*备注                                   */
                                     /*備註                              genero*/
ola272      varchar2(255),           /*备注                                   */
                                     /*no use                            genero*/
ola273      varchar2(255),           /*备注                                   */
                                     /*no use                            genero*/
ola28       varchar2(20),            /*凭证号码                               */
                                     /*傳票號碼    (99/05/11)                 */
ola29       varchar2(1),             /*可否分批                               */
                                     /*可否分批 (Y/N)                         */
ola30       varchar2(1),             /*可否转运                               */
                                     /*可否轉運 (Y/N)                         */
ola31       varchar2(20),            /*许可证号                               */
                                     /*許可證號                               */
ola32       varchar2(10),            /*科目类型                               */
                                     /*科目類別    (99/05/11)                 */
ola33       date,                    /*凭证日期                               */
                                     /*傳票日期    (99/05/21)                 */
ola34       varchar2(1),             /*No Use                                 */
ola35       varchar2(1),             /*No Use                                 */
ola36       varchar2(1),             /*No Use                                 */
ola37       varchar2(1),             /*会计/进出口审核                        */
                                     /*會計/進出口確認                        */
ola38       varchar2(10),            /*会计/进出口审核者ID                    */
                                     /*會計/進出口確認者ID                    */
ola39       varchar2(10),            /*审核者                                 */
                                     /*確認者                                 */
ola40       varchar2(1),             /*结案否                                 */
                                     /*結案否                                 */
olaconf     varchar2(1),             /*审核否                                 */
                                     /*確認否 (Y/N/X)                         */
olauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
olagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
olamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
oladate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
ola41       varchar2(10),            /*出货来源营运中心代码                   */
ola42       varchar2(10),            /*部门                                   */
ola930      varchar2(10),            /*成本中心                               */
olaud01     varchar2(255),           /*自订字段-Textedit                      */
olaud02     varchar2(40),            /*自订字段-文字                          */
olaud03     varchar2(40),            /*自订字段-文字                          */
olaud04     varchar2(40),            /*自订字段-文字                          */
olaud05     varchar2(40),            /*自订字段-文字                          */
olaud06     varchar2(40),            /*自订字段-文字                          */
olaud07     number(15,3),            /*自订字段-数值                          */
olaud08     number(15,3),            /*自订字段-数值                          */
olaud09     number(15,3),            /*自订字段-数值                          */
olaud10     number(10),              /*自订字段-整数                          */
olaud11     number(10),              /*自订字段-整数                          */
olaud12     number(10),              /*自订字段-整数                          */
olaud13     date,                    /*自订字段-日期                          */
olaud14     date,                    /*自订字段-日期                          */
olaud15     date,                    /*自订字段-日期                          */
olalegal    varchar2(10) NOT NULL,   /*所属法人                               */
olaoriu     varchar2(10),            /*资料建立者                             */
olaorig     varchar2(10)             /*资料建立部门                           */
);

create unique index ola_02 on ola_file (ola04);
create        index ola_03 on ola_file (ola28);
alter table ola_file add  constraint ola_pk primary key  (ola01) enable validate;
grant select on ola_file to tiptopgp;
grant update on ola_file to tiptopgp;
grant delete on ola_file to tiptopgp;
grant insert on ola_file to tiptopgp;
grant index on ola_file to public;
grant select on ola_file to ods;
