/*
================================================================================
檔案代號:zh_file
檔案名稱:统计图型单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zh_file
(
zh01        varchar2(5) NOT NULL,    /*图形编号                               */
                                     /*圖形代號                               */
zh02        number(5) NOT NULL,      /*ITEM 序号                              */
                                     /*ITEM 序號                              */
zh03        varchar2(255),           /*资料来源-2                             */
                                     /*資料來源-2                             */
                                     /*    where ab01 = '1101'                */
zh04        number(5)                /*+/-                                    */
);

alter table zh_file add  constraint zh_pk primary key  (zh01,zh02) enable validate;
grant select on zh_file to tiptopgp;
grant update on zh_file to tiptopgp;
grant delete on zh_file to tiptopgp;
grant insert on zh_file to tiptopgp;
grant index on zh_file to public;
grant select on zh_file to ods;
