/*
================================================================================
檔案代號:oer_file
檔案名稱:订单变更单备注档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oer_file
(
oer01       varchar2(20) NOT NULL,   /*订单单号                               */
                                     /*訂單單號                               */
oer02       number(5) NOT NULL,      /*变更序号                               */
                                     /*變更序號                               */
oer03       number(5) NOT NULL,      /*行序                                   */
oer04       varchar2(255),           /*备注说明                               */
                                     /*備註說明                               */
oerplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oerlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table oer_file add  constraint oer_pk primary key  (oer01,oer02,oer03) enable validate;
grant select on oer_file to tiptopgp;
grant update on oer_file to tiptopgp;
grant delete on oer_file to tiptopgp;
grant insert on oer_file to tiptopgp;
grant index on oer_file to public;
grant select on oer_file to ods;
