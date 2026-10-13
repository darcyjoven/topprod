/*
================================================================================
檔案代號:gan_file
檔案名稱:程序历程维护作业单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gan_file
(
gan01       number(5) NOT NULL,      /*历程编号                               */
                                     /*歷程編號                               */
gan02       varchar2(20) NOT NULL,   /*程序名称                               */
                                     /*程式名稱                               */
gan03       varchar2(255),           /*说明                                   */
                                     /*說明                                   */
ganmodu     varchar2(10),            /*MODIFY USER                            */
gandate     date                     /*MODIFY DATE                            */
);

alter table gan_file add  constraint gan_pk primary key  (gan01,gan02) enable validate;
grant select on gan_file to tiptopgp;
grant update on gan_file to tiptopgp;
grant delete on gan_file to tiptopgp;
grant insert on gan_file to tiptopgp;
grant index on gan_file to public;
grant select on gan_file to ods;
