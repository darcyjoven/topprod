/*
================================================================================
檔案代號:rpe_file
檔案名稱:族群料件关连档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rpe_file
(
rpe01       varchar2(40) NOT NULL,   /*族群料件                               */
                                     /*必須其來源碼性質為Family Part,Configue */
                                     /*Part ('A','C')                         */
                                     /*Family Part 之成員組件為(F,C)          */
                                     /*Configue Part 之成員組件為(T)          */
rpe02       number(5) NOT NULL,      /*序号                                   */
                                     /*序號                                   */
                                     /*此為系統內部自行維護序號               */
rpe03       varchar2(40) NOT NULL,   /*成员料件                               */
                                     /*成員料件                               */
                                     /*必須其來源碼性質為Family Part, Configur-*/
                                     /*ed part,FAS(T)                         */
rpe04       date NOT NULL,           /*生效日期                               */
rpe05       date                     /*失效日期                               */
);

alter table rpe_file add  constraint rpe_pk primary key  (rpe01,rpe02,rpe03,rpe04) enable validate;
grant select on rpe_file to tiptopgp;
grant update on rpe_file to tiptopgp;
grant delete on rpe_file to tiptopgp;
grant insert on rpe_file to tiptopgp;
grant index on rpe_file to public;
grant select on rpe_file to ods;
