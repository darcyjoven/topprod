/*
================================================================================
檔案代號:axt_file
檔案名稱:对冲科目misc明细科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axt_file
(
axt00       varchar2(5) NOT NULL,    /*母公司账套                             */
axt01       varchar2(24) NOT NULL,   /*母(子)公司科目编号                     */
axt03       varchar2(24) NOT NULL,   /*子公司科目编号                         */
axt04       varchar2(1),             /*是否依据公式设置                       */
axt05       varchar2(1),             /*是否依股权冲销                         */
axt06       varchar2(1),             /*少数股权否                             */
axt09       varchar2(10) NOT NULL,   /*来源：母(子)公司编号                   */
axt10       varchar2(10) NOT NULL,   /*对冲：子公司编号                       */
axt12       varchar2(5) NOT NULL,    /*子公司账套                             */
axt13       varchar2(10) DEFAULT ' ' NOT NULL /*集团代号*/
);

alter table axt_file add  constraint axt_pk primary key  (axt00,axt01,axt03,axt09,axt10,axt12,axt13) enable validate;
grant select on axt_file to tiptopgp;
grant update on axt_file to tiptopgp;
grant delete on axt_file to tiptopgp;
grant insert on axt_file to tiptopgp;
grant index on axt_file to public;
grant select on axt_file to ods;
