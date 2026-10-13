/*
================================================================================
檔案代號:zav_file
檔案名稱:自定义动态查询设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zav_file
(
zav01       varchar2(1) NOT NULL,    /*程序使用                               */
                                     /*1.per                                  */
                                     /*2.query                                */
zav02       varchar2(80) NOT NULL,   /*程序代码/查询单id                      */
zav03       varchar2(20) NOT NULL,   /*字段代码                               */
zav04       varchar2(1) NOT NULL,    /*客制码                                 */
zav05       varchar2(10) NOT NULL,   /*行业别代码                             */
zav06       varchar2(1),             /*是否需要construct                      */
zav07       varchar2(255),           /*查询资料的条件                         */
zav08       varchar2(5),             /*缺省值自选或固定值                     */
zav09       varchar2(80),            /*开窗字段的缺省值1                      */
zav10       varchar2(80),            /*开窗字段的缺省值2                      */
zav11       varchar2(80),            /*开窗字段的缺省值3                      */
zav12       varchar2(80),            /*开窗字段的缺省值4                      */
zav13       varchar2(80),            /*开窗字段的缺省值5                      */
zav14       varchar2(9),             /*参数自选或固定值                       */
zav15       varchar2(80),            /*arg1                                   */
zav16       varchar2(80),            /*arg2                                   */
zav17       varchar2(80),            /*arg3                                   */
zav18       varchar2(80),            /*arg4                                   */
zav19       varchar2(80),            /*arg5                                   */
zav20       varchar2(80),            /*arg6                                   */
zav21       varchar2(80),            /*arg7                                   */
zav22       varchar2(80),            /*arg8                                   */
zav23       varchar2(80),            /*arg9                                   */
zav24       varchar2(1) NOT NULL     /*开窗状态                               */
);

alter table zav_file add  constraint zav_pk primary key  (zav01,zav02,zav03,zav04,zav05,zav24) enable validate;
grant select on zav_file to tiptopgp;
grant update on zav_file to tiptopgp;
grant delete on zav_file to tiptopgp;
grant insert on zav_file to tiptopgp;
grant index on zav_file to public;
grant select on zav_file to ods;
