/*
================================================================================
檔案代號:oac_file
檔案名稱:运输地点档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oac_file
(
oac01       varchar2(10) NOT NULL,   /*运输地点代码                           */
                                     /*運輸地點代碼                           */
oac02       varchar2(80)             /*运输地点名称                           */
);

alter table oac_file add  constraint oac_pk primary key  (oac01) enable validate;
grant select on oac_file to tiptopgp;
grant update on oac_file to tiptopgp;
grant delete on oac_file to tiptopgp;
grant insert on oac_file to tiptopgp;
grant index on oac_file to public;
grant select on oac_file to ods;
