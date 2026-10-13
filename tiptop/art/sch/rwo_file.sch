/*
================================================================================
檔案代號:rwo_file
檔案名稱:促销限定资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rwo_file
(
rwo01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rwo02       varchar2(20) DEFAULT ' ' NOT NULL, /*活动代码*/
rwo03       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
                                     /*Promotion Type                         */
                                     /*1:Special Product Price 2:Special Brand Class.  Price 3:Special Price-Interval Price 6.Full Amount Promotion 9.Rebate Promotion*/
rwo04       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rwo05       varchar2(1) DEFAULT ' ' NOT NULL, /*限定类别*/
                                     /*Limit Category 1:By Goods 2:By Brand Class.*/
rwo06       number(5) DEFAULT '0' NOT NULL, /*项次*/
rwo07       varchar2(40),            /*限定代码                               */
rwolegal    varchar2(10) NOT NULL,   /*所属法人                               */
rwoplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table rwo_file add  constraint rwo_pk primary key  (rwo01,rwo02,rwo03,rwo04,rwo05,rwo06,rwoplant) enable validate;
grant select on rwo_file to tiptopgp;
grant update on rwo_file to tiptopgp;
grant delete on rwo_file to tiptopgp;
grant insert on rwo_file to tiptopgp;
grant index on rwo_file to public;
grant select on rwo_file to ods;
