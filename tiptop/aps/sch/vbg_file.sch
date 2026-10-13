/*
================================================================================
檔案代號:vbg_file
檔案名稱:APS制程外包
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vbg_file
(
vbg01       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
vbg02       varchar2(80) DEFAULT ' ' NOT NULL, /*工艺路线*/
vbg03       varchar2(60) DEFAULT ' ' NOT NULL, /*加工序号*/
vbg04       varchar2(6) DEFAULT ' ' NOT NULL, /*作业编号*/
vbg05       varchar2(10),            /*外包商编号                             */
vbg06       number(1),               /*外包类型                               */
vbg07       date,                    /*开始时间(日期)                         */
vbg08       date,                    /*结束时间(日期)                         */
vbg09       number(9),               /*作业时间                               */
vbg10       number(1),               /*是否排程                               */
vbg11       number(9),               /*外包商序号                             */
vbg12       number(15,3),            /*外包数量                               */
vbgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
vbglegal    varchar2(10) NOT NULL,   /*所属法人                               */
vbg13       varchar2(60),            /*APS保留字段文字                        */
vbg14       varchar2(60),            /*APS保留字段文字                        */
vbg15       varchar2(60),            /*APS保留字段文字                        */
vbg16       number(9),               /*APS保留字段数值                        */
vbg17       number(18,8),            /*APS保留字段浮点数                      */
vbg18       number(18,8),            /*APS保留字段浮点数                      */
vbg19       date,                    /*APS保留字段日期                        */
vbg20       date,                    /*APS保留字段日期                        */
vbg012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table vbg_file add  constraint vbg_pk primary key  (vbglegal,vbgplant,vbg01,vbg02,vbg03,vbg04,vbg012) enable validate;
grant select on vbg_file to tiptopgp;
grant update on vbg_file to tiptopgp;
grant delete on vbg_file to tiptopgp;
grant insert on vbg_file to tiptopgp;
grant index on vbg_file to public;
grant select on vbg_file to ods;
