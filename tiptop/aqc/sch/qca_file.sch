/*
================================================================================
檔案代號:qca_file
檔案名稱:一般检验水准样本代码资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table qca_file
(
qca01       number(10) NOT NULL,     /*起始批量                               */
qca02       number(10) NOT NULL,     /*截止批量                               */
qca03       varchar2(1) NOT NULL,    /*样本字号                               */
                                     /*樣本字號                               */
qca04       number(5),               /*正常检验样本收                         */
                                     /*正常檢驗樣本收                         */
qca05       number(5),               /*加严检验样本收                         */
                                     /*加嚴檢驗樣本收                         */
qca06       number(5),               /*减量检验样本收                         */
                                     /*減量檢驗樣本收                         */
qca07       varchar2(1) NOT NULL     /*级数                                   */
                                     /*級數                                   */
);

alter table qca_file add  constraint qca_pk primary key  (qca01,qca02,qca03,qca07) enable validate;
grant select on qca_file to tiptopgp;
grant update on qca_file to tiptopgp;
grant delete on qca_file to tiptopgp;
grant insert on qca_file to tiptopgp;
grant index on qca_file to public;
grant select on qca_file to ods;
