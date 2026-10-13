/*
================================================================================
檔案代號:fbe_file
檔案名稱:资产出售单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fbe_file
(
fbe01       varchar2(20) NOT NULL,   /*出售单号                               */
fbe02       date,                    /*出售日期                               */
fbe03       varchar2(10),            /*销售客户                               */
fbe04       varchar2(10),            /*送货客户                               */
fbe05       varchar2(4),             /*币种                                   */
fbe06       number(20,10),           /*汇率                                   */
fbe07       varchar2(4),             /*税种                                   */
fbe071      number(9,4),             /*税率                                   */
fbe072      varchar2(1),             /*联数                                   */
fbe073      varchar2(1),             /*含税否                                 */
fbe08       number(20,6),            /*原币出售税前金额                       */
fbe08x      number(20,6),            /*原币出售税额                           */
fbe08t      number(20,6),            /*原币出售含税金额                       */
fbe09       number(20,6),            /*本币出售税前金额                       */
fbe09x      number(20,6),            /*本币出售税额                           */
fbe09t      number(20,6),            /*本币出售含税金额                       */
fbe10       number(20,6),            /*处份资产损益                           */
fbe11       varchar2(20),            /*帐单号码                               */
fbe12       varchar2(1),             /*重计否                                 */
fbe13       varchar2(1),             /*No Use                                 */
fbe14       varchar2(20),            /*凭证号码                               */
fbe15       date,                    /*凭证日期                               */
fbeconf     varchar2(1),             /*确认码                                 */
fbepost     varchar2(1),             /*过帐码                                 */
fbepost2    varchar2(1),             /*税签过帐码                             */
fbeprsw     number(5),               /*打印次数                               */
fbeuser     varchar2(10),            /*资料所有者                             */
fbegrup     varchar2(10),            /*资料所有群                             */
fbemodu     varchar2(10),            /*资料更改者                             */
fbedate     date,                    /*最近更改日                             */
fbe16       varchar2(10),            /*申请人                                 */
fbe17       varchar2(10),            /*申请部门                               */
fbe18       varchar2(1),             /*状况码                                 */
fbemksg     varchar2(1),             /*签核否？                               */
fbeud01     varchar2(255),           /*自订字段-Textedit                      */
fbeud02     varchar2(40),            /*自订字段-文字                          */
fbeud03     varchar2(40),            /*自订字段-文字                          */
fbeud04     varchar2(40),            /*自订字段-文字                          */
fbeud05     varchar2(40),            /*自订字段-文字                          */
fbeud06     varchar2(40),            /*自订字段-文字                          */
fbeud07     number(15,3),            /*自订字段-数值                          */
fbeud08     number(15,3),            /*自订字段-数值                          */
fbeud09     number(15,3),            /*自订字段-数值                          */
fbeud10     number(10),              /*自订字段-整数                          */
fbeud11     number(10),              /*自订字段-整数                          */
fbeud12     number(10),              /*自订字段-整数                          */
fbeud13     date,                    /*自订字段-日期                          */
fbeud14     date,                    /*自订字段-日期                          */
fbeud15     date,                    /*自订字段-日期                          */
fbe031      varchar2(40),            /*销售客户简称                           */
fbe041      varchar2(40),            /*送货客户简称                           */
fbelegal    varchar2(10) NOT NULL,   /*所属法人                               */
fbeoriu     varchar2(10),            /*资料建立者                             */
fbeorig     varchar2(10),            /*资料建立部门                           */
fbe142      varchar2(20),            /*传票编号(财签二)                       */
fbe152      date                     /*传票日期(财签二)                       */
);

create        index fbe_02 on fbe_file (fbe14);
alter table fbe_file add  constraint fbe_pk primary key  (fbe01) enable validate;
grant select on fbe_file to tiptopgp;
grant update on fbe_file to tiptopgp;
grant delete on fbe_file to tiptopgp;
grant insert on fbe_file to tiptopgp;
grant index on fbe_file to public;
grant select on fbe_file to ods;
