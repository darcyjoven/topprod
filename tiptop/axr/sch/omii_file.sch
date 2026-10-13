/*
================================================================================
檔案代號:omii_file
檔案名稱:信用評等帳齡及備抵呆帳提列率檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table omii_file
(
omii00      varchar2(10) DEFAULT ' ' NOT NULL, /*信用評等帳齡類別*/
omii01      number(5),               /*第 1 段帐龄天数                        */
omii011     number(15,6),            /*第一段计提率                           */
omii02      number(5),               /*第2 段帳齡天數                         */
omii021     number(15,6),            /*第二段计提率                           */
omii03      number(5),               /*第 3 段帐龄天数                        */
omii031     number(15,6),            /*第三段计提率                           */
omii04      number(5),               /*第 4 段帐龄天数                        */
omii041     number(15,6),            /*第四段计提率                           */
omii05      number(5),               /*第 5 段帐龄天数                        */
omii051     number(15,6),            /*第五段计提率                           */
omii06      number(5),               /*第 6 段帐龄天数                        */
omii061     number(15,6),            /*第六段计提率                           */
omii07      varchar2(10),            /*帐龄类型                               */
omii08      varchar2(10),            /*第1段信用評等類別                      */
omii09      varchar2(10),            /*第2段信用評等類別                      */
omii10      varchar2(10),            /*第3段信用評等類別                      */
omii11      varchar2(10),            /*第4段信用評等類別                      */
omii12      varchar2(10),            /*第5段信用評等類別                      */
omii13      varchar2(10),            /*第6段信用評等類別                      */
omii14      varchar2(10),            /*第7段信用評等類別                      */
omii15      varchar2(10),            /*第8段信用評等類別                      */
omii16      varchar2(10),            /*第9段信用評等類別                      */
omii17      varchar2(10),            /*第10段信用評等類別                     */
omii18      varchar2(1) DEFAULT 'Y' NOT NULL /*是否依帳齡分段*/
);

alter table omii_file add  constraint omii_pk primary key  (omii00) enable validate;
grant select on omii_file to tiptopgp;
grant update on omii_file to tiptopgp;
grant delete on omii_file to tiptopgp;
grant insert on omii_file to tiptopgp;
grant index on omii_file to public;
grant select on omii_file to ods;
