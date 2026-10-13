/*
================================================================================
檔案代號:cgc_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cgc_file
(
cgc01       varchar2(100),           /*项目名称                               */
cgc02       number(5),               /*项次                                   */
cgc03       varchar2(100),           /*函数名称                               */
cgc04       varchar2(1000),          /*说明                                   */
cgc05       date,                    /*建立日期                               */
cgc06       date,                    /*最后异动日期                           */
cgc07       varchar2(20),            /*测试命令                               */
cgc08       varchar2(20),
cgc09       varchar2(20),
cgc10       date,
cgc11       date,
cgc12       date,
cgc13       number(5),
cgc14       number(5),
cgc15       number(5)
);

grant select on cgc_file to tiptopgp;
grant update on cgc_file to tiptopgp;
grant delete on cgc_file to tiptopgp;
grant insert on cgc_file to tiptopgp;
grant index on cgc_file to public;
grant select on cgc_file to ods;
