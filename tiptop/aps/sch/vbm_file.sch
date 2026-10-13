/*
================================================================================
檔案代號:vbm_file
檔案名稱:途程制程指定工具
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vbm_file
(
vbm01       varchar2(80) NOT NULL,   /*工艺路线                               */
vbm02       varchar2(60) NOT NULL,   /*工艺路线中的加工序号                   */
vbm03       varchar2(60) NOT NULL,   /*作业编号                               */
vbm04       varchar2(60) NOT NULL,   /*工具编号                               */
vbm05       number(9) DEFAULT '1' NOT NULL, /*替代工具组的优先次序*/
vbmplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
vbmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
vbm06       varchar2(60),            /*APS保留字段文字                        */
vbm07       varchar2(60),            /*APS保留字段文字                        */
vbm08       varchar2(60),            /*APS保留字段文字                        */
vbm09       number(9),               /*APS保留字段数值                        */
vbm10       number(18,8),            /*APS保留字段浮点数                      */
vbm11       number(18,8),            /*APS保留字段浮点数                      */
vbm12       date,                    /*APS保留字段日期                        */
vbm13       date,                    /*APS保留字段日期                        */
vbm14       varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table vbm_file add  constraint vbm_pk primary key  (vbmlegal,vbmplant,vbm01,vbm02,vbm03,vbm04,vbm14) enable validate;
grant select on vbm_file to tiptopgp;
grant update on vbm_file to tiptopgp;
grant delete on vbm_file to tiptopgp;
grant insert on vbm_file to tiptopgp;
grant index on vbm_file to public;
grant select on vbm_file to ods;
