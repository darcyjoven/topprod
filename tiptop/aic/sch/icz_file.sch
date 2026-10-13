/*
================================================================================
檔案代號:icz_file
檔案名稱:库存Hold批Log档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table icz_file
(
icz01       varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
icz02       varchar2(10) DEFAULT ' ' NOT NULL, /*仓库编号*/
icz03       varchar2(10) DEFAULT ' ' NOT NULL, /*库位编号*/
icz04       varchar2(24) DEFAULT ' ' NOT NULL, /*批号*/
icz05       varchar2(1),             /*状态                                   */
icz06       varchar2(255),           /*说明                                   */
icz07       date,                    /*异动日期                               */
icz08       varchar2(1),             /*no use                                 */
icz09       varchar2(40),            /*母体料号                               */
icz10       varchar2(24),            /*母批                                   */
iczdate     date,                    /*最近更改日                             */
iczgrup     varchar2(10),            /*资料所有部门                           */
iczmodu     varchar2(10),            /*资料更改者                             */
iczuser     varchar2(10),            /*资料所有者                             */
iczplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
iczlegal    varchar2(10) NOT NULL,   /*所属法人                               */
iczorig     varchar2(10),            /*资料建立部门                           */
iczoriu     varchar2(10),            /*资料建立者                             */
icz11       number(5) DEFAULT '1' NOT NULL /*项次*/
);

alter table icz_file add  constraint icz_pk primary key  (icz01,icz02,icz03,icz04,icz11) enable validate;
grant select on icz_file to tiptopgp;
grant update on icz_file to tiptopgp;
grant delete on icz_file to tiptopgp;
grant insert on icz_file to tiptopgp;
grant index on icz_file to public;
grant select on icz_file to ods;
