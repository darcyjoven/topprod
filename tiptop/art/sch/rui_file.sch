/*
================================================================================
檔案代號:rui_file
檔案名稱:库存调整申请单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rui_file
(
rui00       varchar2(10) DEFAULT ' ',/*no use                                 */
rui01       varchar2(20) DEFAULT ' ' NOT NULL, /*调整单号*/
rui02       varchar2(20),            /*来源单号                               */
                                     /*Source Type 1.By Hand 2.POS            */
rui03       varchar2(10),            /*需求营运中心                           */
rui04       varchar2(10),            /*出货营运中心                           */
rui05       varchar2(10),            /*配送機構                               */
rui06       varchar2(255),           /*備注                                   */
ruiacti     varchar2(1),             /*资料有效码                             */
ruicond     date,                    /*审核日期                               */
ruiconf     varchar2(1),             /*审核码                                 */
ruicont     varchar2(8),             /*审核时间                               */
ruiconu     varchar2(10),            /*审核人员                               */
ruicrat     date,                    /*资料创建日                             */
ruidate     date,                    /*最近更改日                             */
ruigrup     varchar2(10),            /*资料所有部门                           */
ruimodu     varchar2(10),            /*资料更改者                             */
ruiuser     varchar2(10),            /*资料所有者                             */
ruioriu     varchar2(10),            /*资料建立者                             */
ruiorig     varchar2(10),            /*资料建立部门                           */
rui07       varchar2(8),             /*流程編號                               */
rui08       varchar2(1) DEFAULT ' ' NOT NULL, /*來源類型0.手工錄入 1.收貨單2.*/
rui09       varchar2(1) DEFAULT 'N' NOT NULL, /*核准否*/
rui10       varchar2(1) DEFAULT 'N' NOT NULL, /*过帐否*/
ruilegal    varchar2(10) NOT NULL,   /*所属法人                               */
ruiplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table rui_file add  constraint rui_pk primary key  (rui01) enable validate;
grant select on rui_file to tiptopgp;
grant update on rui_file to tiptopgp;
grant delete on rui_file to tiptopgp;
grant insert on rui_file to tiptopgp;
grant index on rui_file to public;
grant select on rui_file to ods;
