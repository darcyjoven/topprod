/*
================================================================================
檔案代號:skq_file
檔案名稱:工单版片资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table skq_file
(
skq01       varchar2(20) DEFAULT ' ' NOT NULL, /*工单单号*/
skq02       varchar2(40) DEFAULT ' ' NOT NULL, /*产品料号*/
skq03       number(10) NOT NULL,     /*工艺序号                               */
skq04       date,                    /*首次移转日                             */
skq05       date,                    /*近期移转日                             */
skq06       varchar2(10),            /*生产部门                               */
skq07       varchar2(255),           /*备注                                   */
skq08       varchar2(1),             /*审核码                                 */
skqacti     varchar2(1),             /*资料有效码                             */
skqdate     date,                    /*最近更改日                             */
skqgrup     varchar2(10),            /*资料所属群组                           */
skqmodu     varchar2(10),            /*资料更改者                             */
skquser     varchar2(10),            /*资料所有者                             */
skqplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
skqlegal    varchar2(10) NOT NULL,   /*所属法人                               */
skqoriu     varchar2(10),            /*资料建立者                             */
skqorig     varchar2(10)             /*资料建立部门                           */
);

alter table skq_file add  constraint skq_pk primary key  (skq01,skq03) enable validate;
grant select on skq_file to tiptopgp;
grant update on skq_file to tiptopgp;
grant delete on skq_file to tiptopgp;
grant insert on skq_file to tiptopgp;
grant index on skq_file to public;
grant select on skq_file to ods;
