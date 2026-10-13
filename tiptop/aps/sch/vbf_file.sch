/*
================================================================================
檔案代號:vbf_file
檔案名稱:APS制令外包
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vbf_file
(
vbf01       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
vbf02       varchar2(10),            /*外包商编号                             */
vbf03       number(1),               /*外包类型                               */
vbf04       date,                    /*开始时间(日期)                         */
vbf05       date,                    /*结束时间(日期)                         */
vbf06       number(9),               /*作业时间                               */
vbf07       number(1),               /*是否已排程                             */
vbfplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
vbflegal    varchar2(10) NOT NULL,   /*所属法人                               */
vbf08       varchar2(60),            /*APS保留字段文字                        */
vbf09       varchar2(60),            /*APS保留字段文字                        */
vbf10       varchar2(60),            /*APS保留字段文字                        */
vbf11       number(9),               /*APS保留字段数值                        */
vbf12       number(18,8),            /*APS保留字段浮点数                      */
vbf13       number(18,8),            /*APS保留字段浮点数                      */
vbf14       date,                    /*APS保留字段日期                        */
vbf15       date                     /*APS保留字段日期                        */
);

alter table vbf_file add  constraint vbf_pk primary key  (vbflegal,vbfplant,vbf01) enable validate;
grant select on vbf_file to tiptopgp;
grant update on vbf_file to tiptopgp;
grant delete on vbf_file to tiptopgp;
grant insert on vbf_file to tiptopgp;
grant index on vbf_file to public;
grant select on vbf_file to ods;
