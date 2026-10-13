/*
================================================================================
檔案代號:sgl_file
檔案名稱:飞票报工档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sgl_file
(
sgl01       varchar2(20) DEFAULT ' ' NOT NULL, /*报工单号*/
sgl02       number(10) DEFAULT '0' NOT NULL, /*项次*/
sgl03       varchar2(40),            /*飞票号码                               */
sgl04       varchar2(20) DEFAULT ' ' NOT NULL, /*工单号码*/
sgl05       varchar2(40) DEFAULT ' ' NOT NULL, /*产品料号*/
sgl06       number(5),               /*工序                                   */
sgl07       varchar2(10) DEFAULT ' ' NOT NULL, /*作业单元编号*/
sgl08       number(15,3) DEFAULT '0' NOT NULL, /*良品完成数量*/
sgl09       number(15,3) DEFAULT '0' NOT NULL, /*报废数量*/
sgl10       varchar2(4) DEFAULT ' ' NOT NULL, /*单位*/
sgl11       number(8,4),             /*实际工时                               */
sgl12       varchar2(10) DEFAULT ' ' NOT NULL, /*员工编号*/
sgl13       varchar2(255),           /*備注                                   */
sglplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sgllegal    varchar2(10) NOT NULL,   /*所属法人                               */
sgl012      varchar2(10)             /*工艺段号                               */
);

alter table sgl_file add  constraint sgl_pk primary key  (sgl01,sgl02) enable validate;
grant select on sgl_file to tiptopgp;
grant update on sgl_file to tiptopgp;
grant delete on sgl_file to tiptopgp;
grant insert on sgl_file to tiptopgp;
grant index on sgl_file to public;
grant select on sgl_file to ods;
