/*
================================================================================
檔案代號:rtp_file
檔案名稱:合同生效工廠單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rtp_file
(
rtp01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同编号*/
rtp02       number(5) DEFAULT '0' NOT NULL, /*版本号*/
rtp03       varchar2(10) DEFAULT ' ' NOT NULL, /*签订机构*/
rtp04       number(5) DEFAULT '0' NOT NULL, /*项次*/
rtp05       varchar2(10),            /*营运中心代码                           */
rtplegal    varchar2(10) NOT NULL,   /*所属法人                               */
rtpplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table rtp_file add  constraint rtp_pk primary key  (rtp01,rtp02,rtp03,rtp04,rtpplant) enable validate;
grant select on rtp_file to tiptopgp;
grant update on rtp_file to tiptopgp;
grant delete on rtp_file to tiptopgp;
grant insert on rtp_file to tiptopgp;
grant index on rtp_file to public;
grant select on rtp_file to ods;
