/*
================================================================================
檔案代號:cet_file
檔案名稱:出囗异动明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cet_file
(
cet01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
cet02       number(10) DEFAULT '0' NOT NULL, /*项次*/
cet03       date,                    /*单据日期                               */
cet04       varchar2(40),            /*料件编号                               */
cet05       varchar2(10),            /*客户编号                               */
cet06       varchar2(40),            /*客户简称                               */
cet07       varchar2(20),            /*报单编号                               */
cet08       date,                    /*报单日期                               */
cet09       varchar2(1),             /*异动方式                               */
cet10       varchar2(40),            /*商品编号                               */
cet11       varchar2(10),            /*海关编号                               */
cet12       varchar2(10),            /*异动指令编号                           */
cet13       number(15,3),            /*异动数量                               */
cet14       varchar2(4),             /*异动单位                               */
cet15       number(15,3),            /*异动数量(合同)                         */
cet16       varchar2(4),             /*异动单位(合同)                         */
cet17       varchar2(10),            /*BOM版本编号                            */
cet18       varchar2(1),             /*报关否                                 */
cet19       number(15,6),            /*no use                                 */
cet20       varchar2(1),             /*冲帐否                                 */
cet21       date,                    /*起始日期                               */
cet22       date,                    /*截止日期                               */
cet23       varchar2(10),            /*客户编号                               */
cet24       varchar2(10),            /*交运方式                               */
cet25       varchar2(20),            /*提运单号                               */
cet26       varchar2(10),            /*成交方式                               */
cet27       varchar2(20),            /*批准文号                               */
cet28       varchar2(10),            /*用途                                   */
cet29       varchar2(20),            /*出口报关单号                           */
cet30       varchar2(10),            /*归并后序号                             */
cet31       number(15,3),            /*法定数量一                             */
cet32       number(15,3),            /*法定数量二                             */
cet33       number(15,3),            /*净重                                   */
cet34       varchar2(20),            /*Invoice No.                            */
cet35       varchar2(4),             /*币种                                   */
cet36       number(20,6),            /*单价                                   */
cet37       number(20,6),            /*总价                                   */
cet38       varchar2(10),            /*产销国                                 */
cetacti     varchar2(1),             /*资料有效码                             */
cetconf     varchar2(1),             /*确认码                                 */
cetdate     date,                    /*最近更改日                             */
cetgrup     varchar2(10),            /*资料所有部门                           */
cetmodu     varchar2(10),            /*资料更改者                             */
cetuser     varchar2(10),            /*资料所有者                             */
cetlegal    varchar2(10) NOT NULL,   /*所属法人                               */
cetplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cetorig     varchar2(10),            /*资料建立部门                           */
cetoriu     varchar2(10)             /*资料建立者                             */
);

create        index cet_01 on cet_file (cet10,cet11,cet17);
alter table cet_file add  constraint cet_pk primary key  (cet01,cet02) enable validate;
grant select on cet_file to tiptopgp;
grant update on cet_file to tiptopgp;
grant delete on cet_file to tiptopgp;
grant insert on cet_file to tiptopgp;
grant index on cet_file to public;
grant select on cet_file to ods;
