/*
================================================================================
檔案代號:npy_file
檔案名稱:票据格式设置单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table npy_file
(
npy01       varchar2(10) NOT NULL,   /*格式编号                               */
                                     /*格式代號                               */
npy02       number(5) NOT NULL,      /*单据项次                               */
                                     /*單據項次                               */
npy03       varchar2(10),            /*打印项目                               */
                                     /*列印項目                               */
npy04       number(5),               /*空几列                                 */
                                     /*空幾列                                 */
npy05       number(5),               /*空几行                                 */
                                     /*空幾行                                 */
npy06       varchar2(30),            /*本列结束否                             */
                                     /*本列結束否                             */
npy07       varchar2(30)             /*No Use                                 */
);

alter table npy_file add  constraint npy_pk primary key  (npy01,npy02) enable validate;
grant select on npy_file to tiptopgp;
grant update on npy_file to tiptopgp;
grant delete on npy_file to tiptopgp;
grant insert on npy_file to tiptopgp;
grant index on npy_file to public;
grant select on npy_file to ods;
