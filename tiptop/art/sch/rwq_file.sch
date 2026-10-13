/*
================================================================================
檔案代號:rwq_file
檔案名稱:限定工厂单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rwq_file
(
rwq01       varchar2(10) DEFAULT ' ' NOT NULL, /*限定机构*/
rwq02       varchar2(20) DEFAULT ' ' NOT NULL, /*活动代码*/
rwq03       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
                                     /*Promotion Type                         */
                                     /*1:Special Product Price 2:Special Brand Class.  Price 3:Special Price-Interval Price*/
rwq04       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rwq05       number(5) DEFAULT '0' NOT NULL, /*项次*/
rwq06       varchar2(10),            /*营运中心代码                           */
rwqlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rwqplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table rwq_file add  constraint rwq_pk primary key  (rwq01,rwq02,rwq03,rwq04,rwq05,rwqplant) enable validate;
grant select on rwq_file to tiptopgp;
grant update on rwq_file to tiptopgp;
grant delete on rwq_file to tiptopgp;
grant insert on rwq_file to tiptopgp;
grant index on rwq_file to public;
grant select on rwq_file to ods;
