/*
================================================================================
檔案代號:cxc_file
檔案名稱:库存出库明细资料档
檔案目的:储存出库单冲销入库明细资料
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cxc_file
(
cxc01       varchar2(40) NOT NULL,   /*料件编号                               */
cxc02       number(5) NOT NULL,      /*年度                                   */
cxc03       number(5) NOT NULL,      /*期别                                   */
cxc04       varchar2(20) NOT NULL,   /*出库单号                               */
cxc05       number(5) NOT NULL,      /*项次                                   */
cxc06       varchar2(20) NOT NULL,   /*冲销入库单号                           */
cxc07       number(5) NOT NULL,      /*项次                                   */
cxc08       number(15,3),            /*冲销数量                               */
cxc09       number(20,6),            /*冲销金额                               */
cxc091      number(20,6),            /*冲销金额-材料                          */
cxc092      number(20,6),            /*冲销金额-人工                          */
cxc093      number(20,6),            /*冲销金额-制费                          */
cxc094      number(20,6),            /*冲销金额-加工                          */
cxc095      number(20,6),            /*冲销金额-其他                          */
cxc10       number(20,6),            /*单价                                   */
cxc11       number(5),               /*顺序                                   */
                                     /*此欄位只用於後續報表呈現先進先出的順序 */
cxc12       varchar2(1),             /*No Use                                 */
cxc010      varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cxc011      varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/专案号/利润 */
cxc096      number(20,6) DEFAULT '0',/*冲销金额-制费三                        */
cxc097      number(20,6) DEFAULT '0',/*冲销金额-制费四                        */
cxc098      number(20,6) DEFAULT '0',/*冲销金额-制费五                        */
cxclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index cxc_02 on cxc_file (cxc01,cxc06,cxc07);
create        index cxc_03 on cxc_file (cxc01,cxc04,cxc05);
alter table cxc_file add  constraint cxc_pk primary key  (cxc01,cxc010,cxc011,cxc02,cxc03,cxc04,cxc05,cxc06,cxc07) enable validate;
grant select on cxc_file to tiptopgp;
grant update on cxc_file to tiptopgp;
grant delete on cxc_file to tiptopgp;
grant insert on cxc_file to tiptopgp;
grant index on cxc_file to public;
grant select on cxc_file to ods;
