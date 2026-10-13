/*
================================================================================
檔案代號:tuq_file
檔案名稱:客户库存异动明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table tuq_file
(
tuq01       varchar2(10),            /*客户编号                               */
tuq02       varchar2(40),            /*产品编号                               */
tuq03       varchar2(24),            /*批号                                   */
tuq04       date,                    /*异动日期                               */
tuq05       varchar2(20),            /*原始单据号码                           */
tuq06       varchar2(4),             /*原始单位                               */
tuq07       number(15,3),            /*原始数量                               */
tuq08       number(20,8),            /*换算率                                 */
tuq09       number(15,3),            /*异动数量                               */
tuq10       varchar2(1),             /*异动区分                               */
tuq11       varchar2(1),             /*库存类型                               */
tuq12       varchar2(10),            /*送货客户                               */
tuq051      number(5),               /*来源单据项次                           */
tuqplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tuqlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index tuq_01 on tuq_file (tuq01,tuq02,tuq03,tuq04,tuq05,tuq051,tuq11,tuq12);
grant select on tuq_file to tiptopgp;
grant update on tuq_file to tiptopgp;
grant delete on tuq_file to tiptopgp;
grant insert on tuq_file to tiptopgp;
grant index on tuq_file to public;
grant select on tuq_file to ods;
