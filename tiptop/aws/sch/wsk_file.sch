/*
================================================================================
檔案代號:wsk_file
檔案名稱:easyflow 集成中介暂存档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table wsk_file
(
wsk01       varchar2(20) NOT NULL,   /*FGLSERVER 的值                         */
wsk02       varchar2(10) NOT NULL,   /*用户编号                               */
wsk03       varchar2(20) NOT NULL,   /*程序编号                               */
wsk04       varchar2(5),             /*TIPTOP 表单单别                        */
wsk05       varchar2(80) NOT NULL,   /*TIPTOP 表单单号                        */
wsk06       varchar2(10),            /*填表人                                 */
wsk07       varchar2(10),            /*表单关系人                             */
wsk08       varchar2(20),            /*EasyFlow 单别                          */
wsk09       varchar2(32),            /*EasyFlow 单号                          */
wsk10       varchar2(4),             /*关号                                   */
wsk11       varchar2(4),             /*支号                                   */
wsk12       varchar2(4),             /*流水号                                 */
wsk13       varchar2(4),             /*签核序号                               */
wsk14       varchar2(10),            /*选择资料夹                             */
wsk15       varchar2(1),             /*No Use                                 */
wsk16       varchar2(40)             /*EasyFlowGP 工作编号                    */
);

alter table wsk_file add  constraint wsk_pk primary key  (wsk01,wsk02,wsk03,wsk05) enable validate;
grant select on wsk_file to tiptopgp;
grant update on wsk_file to tiptopgp;
grant delete on wsk_file to tiptopgp;
grant insert on wsk_file to tiptopgp;
grant index on wsk_file to public;
grant select on wsk_file to ods;
