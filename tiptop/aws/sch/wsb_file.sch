/*
================================================================================
檔案代號:wsb_file
檔案名稱:EasyFlow 集成资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wsb_file
(
wsb01       varchar2(20) NOT NULL,   /*程序编号                               */
                                     /*程式代號                               */
wsb02       varchar2(1) NOT NULL,    /*字段性质                               */
                                     /*欄位性質                               */
                                     /*正確值 1/2                             */
                                     /*1:單頭欄位                             */
                                     /*2:單身欄位                             */
wsb03       varchar2(30) NOT NULL,   /*字段名称                               */
                                     /*欄位名稱                               */
wsb04       varchar2(20)             /*参照字段                               */
                                     /*參照欄位                               */
);

alter table wsb_file add  constraint wsb_pk primary key  (wsb01,wsb02,wsb03) enable validate;
grant select on wsb_file to tiptopgp;
grant update on wsb_file to tiptopgp;
grant delete on wsb_file to tiptopgp;
grant insert on wsb_file to tiptopgp;
grant index on wsb_file to public;
grant select on wsb_file to ods;
