/*
================================================================================
檔案代號:pnd_file
檔案名稱:采购变更单备注档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pnd_file
(
pnd01       varchar2(20) NOT NULL,   /*采购单号                               */
                                     /*採購單號                               */
pnd02       number(5) NOT NULL,      /*变更序号                               */
                                     /*變更序號                               */
pnd03       number(5) NOT NULL,      /*行序                                   */
pnd04       varchar2(255),           /*备注说明                               */
                                     /*備註說明                               */
pndplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pndlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table pnd_file add  constraint pnd_pk primary key  (pnd01,pnd02,pnd03) enable validate;
grant select on pnd_file to tiptopgp;
grant update on pnd_file to tiptopgp;
grant delete on pnd_file to tiptopgp;
grant insert on pnd_file to tiptopgp;
grant index on pnd_file to public;
grant select on pnd_file to ods;
