/*
================================================================================
檔案代號:imx_file
檔案名稱:料件属性资料档
檔案目的:记录多属性料件机制中定义的料件属性信息
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table imx_file
(
imx000      varchar2(40) NOT NULL,   /*料件编号                               */
imx00       varchar2(40),            /*父料件编号                             */
imx01       varchar2(80),            /*分组1属性值                            */
imx02       varchar2(80),            /*分组2属性值                            */
imx03       varchar2(80),            /*分组3属性值                            */
imx04       varchar2(80),            /*分组4属性值                            */
imx05       varchar2(80),            /*分组5属性值                            */
imx06       varchar2(80),            /*分组6属性值                            */
imx07       varchar2(80),            /*分组7属性值                            */
imx08       varchar2(80),            /*分组8属性值                            */
imx09       varchar2(80),            /*分组9属性值                            */
imx10       varchar2(80)             /*分组10属性值                           */
);

create        index imx_01 on imx_file (imx01);
alter table imx_file add  constraint imx_pk primary key  (imx000) enable validate;
grant select on imx_file to tiptopgp;
grant update on imx_file to tiptopgp;
grant delete on imx_file to tiptopgp;
grant insert on imx_file to tiptopgp;
grant index on imx_file to public;
grant select on imx_file to ods;
