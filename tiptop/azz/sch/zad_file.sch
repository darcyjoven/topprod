/*
================================================================================
檔案代號:zad_file
檔案名稱:报表连查设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table zad_file
(
zad01       varchar2(20) NOT NULL,   /*程序编号                               */
                                     /*zaa01                                  */
zad02       number(5) NOT NULL,      /*序号                                   */
                                     /*zaa02                                  */
zad03       varchar2(1) NOT NULL,    /*语言别                                 */
                                     /*zaa03                                  */
zad04       varchar2(10) NOT NULL,   /*用户                                   */
                                     /*zaa04                                  */
zad05       varchar2(1) NOT NULL,    /*客制否                                 */
                                     /*zaa10                                  */
zad06       varchar2(20) NOT NULL,   /*报表打印的样板                         */
                                     /*zaa11                                  */
zad07       varchar2(10) NOT NULL,   /*权限类型                               */
                                     /*zaa17                                  */
zad08       number(5) NOT NULL,      /*报表联查序号                           */
zad09       varchar2(1),             /*报表联查类型                           */
                                     /*1:Program Code 2:sql Code              */
zad10       varchar2(10),            /*报表联查内容                           */
zad11       varchar2(255)            /*相关性单别                             */
);

alter table zad_file add  constraint zad_pk primary key  (zad01,zad02,zad03,zad04,zad05,zad06,zad07,zad08) enable validate;
grant select on zad_file to tiptopgp;
grant update on zad_file to tiptopgp;
grant delete on zad_file to tiptopgp;
grant insert on zad_file to tiptopgp;
grant index on zad_file to public;
grant select on zad_file to ods;
