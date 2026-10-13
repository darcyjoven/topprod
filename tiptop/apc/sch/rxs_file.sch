/*
================================================================================
檔案代號:rxs_file
檔案名稱:Webservice差异调整单单头档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rxs_file
(
rxs01       varchar2(20) DEFAULT ' ' NOT NULL, /*调整单号*/
rxs02       date,                    /*单据日期                               */
rxs03       varchar2(10),            /*人员编号                               */
rxs04       varchar2(255),           /*备注                                   */
rxs05       varchar2(1) DEFAULT ' ' NOT NULL, /*状况码*/
rxsacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
rxscond     date,                    /*审核日期                               */
rxsconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
rxscont     varchar2(8),             /*审核时间                               */
rxsconu     varchar2(10),            /*审核人员                               */
rxscrat     date,                    /*资料创建日                             */
rxsdate     date,                    /*最近更改日                             */
rxsgrup     varchar2(10),            /*资料所有群                             */
rxslegal    varchar2(10) NOT NULL,   /*所属法人                               */
rxsmksg     varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
rxsmodu     varchar2(10),            /*资料更改者                             */
rxsorig     varchar2(10),            /*资料建立部门                           */
rxsoriu     varchar2(10),            /*资料建立者                             */
rxsplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rxspost     varchar2(1) DEFAULT ' ' NOT NULL, /*过帐码*/
rxsuser     varchar2(10)             /*资料所有者                             */
);

alter table rxs_file add  constraint rxs_pk primary key  (rxs01) enable validate;
grant select on rxs_file to tiptopgp;
grant update on rxs_file to tiptopgp;
grant delete on rxs_file to tiptopgp;
grant insert on rxs_file to tiptopgp;
grant index on rxs_file to public;
grant select on rxs_file to ods;
