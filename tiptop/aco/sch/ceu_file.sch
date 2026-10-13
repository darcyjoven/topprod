/*
================================================================================
檔案代號:ceu_file
檔案名稱:进囗异动明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ceu_file
(
ceu01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
ceu02       number(10) DEFAULT '0' NOT NULL, /*项次*/
ceu03       date,                    /*单据日期                               */
ceu04       varchar2(40),            /*料件编号                               */
ceu05       varchar2(10),            /*厂商编号                               */
ceu06       varchar2(40),            /*厂商简称                               */
ceu07       varchar2(20),            /*报单编号                               */
ceu08       date,                    /*报单日期                               */
ceu09       varchar2(1),             /*异动方式                               */
ceu10       varchar2(40),            /*商品编号                               */
ceu11       varchar2(20),            /*Invoice No                             */
ceu12       varchar2(10),            /*异动指令编号                           */
ceu13       number(15,3),            /*异动数量                               */
ceu14       varchar2(4),             /*异动单位                               */
ceu15       number(15,3),            /*异动数量(合同)                         */
ceu16       varchar2(4),             /*异动单位(合同)                         */
ceu17       varchar2(10),            /*海关编号                               */
ceu18       varchar2(1),             /*报关否                                 */
ceu19       number(5),               /*收货单项次                             */
ceu20       varchar2(1),             /*冲帐否                                 */
ceu21       date,                    /*申请起始日期                           */
ceu22       date,                    /*申请截止日期                           */
ceu23       varchar2(10),            /*厂商编号                               */
ceu24       varchar2(10),            /*交运方式                               */
ceu25       varchar2(20),            /*提运单号                               */
ceu26       varchar2(10),            /*贸易方式                               */
ceu27       varchar2(10),            /*成交方式                               */
ceu28       varchar2(30),            /*批准文号                               */
ceu29       varchar2(10),            /*用途                                   */
ceu30       varchar2(20),            /*进口报关单号                           */
ceu31       varchar2(10),            /*归并后序号                             */
ceuacti     varchar2(1),             /*资料有效码                             */
ceuconf     varchar2(1),             /*确认码                                 */
ceudate     date,                    /*最近更改日                             */
ceugrup     varchar2(10),            /*资料所有部门                           */
ceumodu     varchar2(10),            /*资料更改者                             */
ceuuser     varchar2(10),            /*资料所有者                             */
ceu32       varchar2(10),            /*产销国                                 */
ceu33       varchar2(10),            /*征免方式                               */
ceulegal    varchar2(10) NOT NULL,   /*所属法人                               */
ceuplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ceuorig     varchar2(10),            /*资料建立部门                           */
ceuoriu     varchar2(10)             /*资料建立者                             */
);

alter table ceu_file add  constraint ceu_pk primary key  (ceu01,ceu02) enable validate;
grant select on ceu_file to tiptopgp;
grant update on ceu_file to tiptopgp;
grant delete on ceu_file to tiptopgp;
grant insert on ceu_file to tiptopgp;
grant index on ceu_file to public;
grant select on ceu_file to ods;
