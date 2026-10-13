/*
================================================================================
檔案代號:vax_file
檔案名稱:APS制令领料状况
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vax_file
(
vax01       varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
vax02       varchar2(40) DEFAULT ' ' NOT NULL, /*元件编号*/
vax03       varchar2(60) DEFAULT ' ' NOT NULL, /*元件序号*/
vax04       varchar2(60) NOT NULL,   /*加工序号                               */
vax05       number(15,3),            /*元件已领用量                           */
vax06       varchar2(10),            /*库房编号                               */
vax07       number(15,3),            /*元件需求量                             */
vax08       varchar2(10),            /*库房库位                               */
vax09       number(1),               /*是否为客供料(0:不是 1:是)              */
vax10       varchar2(6),             /*作业编号                               */
vaxplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
vaxlegal    varchar2(10) NOT NULL,   /*所属法人                               */
vax11       number(1),               /*是否为消耗性料件0：否 1：是            */
vax12       number(15,3),            /*元件真实需求量                         */
vax13       number(15,3),            /*元件损耗需求量                         */
vax14       varchar2(60),            /*APS保留字段文字                        */
vax15       varchar2(60),            /*APS保留字段文字                        */
vax16       varchar2(60),            /*APS保留字段文字                        */
vax17       number(9),               /*APS保留字段数值                        */
vax18       number(18,8),            /*APS保留字段浮点数                      */
vax19       number(18,8),            /*APS保留字段浮点数                      */
vax20       date,                    /*APS保留字段日期                        */
vax21       date,                    /*APS保留字段日期                        */
vax22       varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
vax23       varchar2(60) DEFAULT '0' NOT NULL /*工艺序*/
);

grant select on vax_file to tiptopgp;
grant update on vax_file to tiptopgp;
grant delete on vax_file to tiptopgp;
grant insert on vax_file to tiptopgp;
grant index on vax_file to public;
grant select on vax_file to ods;
