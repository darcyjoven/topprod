/*
================================================================================
檔案代號:pnbi_file
檔案名稱:采购单变更单单身档
檔案目的:采购单变更单单身档
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pnbi_file
(
pnbi01      varchar2(20) DEFAULT ' ' NOT NULL, /*采购单号*/
pnbi02      number(5) DEFAULT '0' NOT NULL, /*变更序号*/
pnbi03      number(10) DEFAULT '0' NOT NULL, /*采购单项次*/
pnbislk01a  varchar2(20),            /*变更前制单号                           */
pnbislk01b  varchar2(20),            /*变更后制单号                           */
pnbiplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
pnbilegal   varchar2(10) NOT NULL    /*所属法人                               */
);

alter table pnbi_file add  constraint pnbi_pk primary key  (pnbi01,pnbi02,pnbi03) enable validate;
grant select on pnbi_file to tiptopgp;
grant update on pnbi_file to tiptopgp;
grant delete on pnbi_file to tiptopgp;
grant insert on pnbi_file to tiptopgp;
grant index on pnbi_file to public;
grant select on pnbi_file to ods;
