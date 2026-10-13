/*
================================================================================
檔案代號:sho_file
檔案名稱:工艺调整资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sho_file
(
sho01       varchar2(20) NOT NULL,   /*调整单号                               */
                                     /*調整單號                               */
sho02       date,                    /*调整日期                               */
                                     /*調整日期                               */
sho03       varchar2(23),            /*Run Card                               */
sho04       varchar2(20),            /*工单单号                               */
sho05       varchar2(1),             /*No Use                                 */
sho06       varchar2(1),             /*调整项目                               */
                                     /*調整項目(1/2/3)                        */
sho07       number(5),               /*调整工艺顺序                           */
                                     /*調整製程順序                           */
sho08       varchar2(6),             /*调整作业编号                           */
                                     /*調整作業編號                           */
sho09       varchar2(10),            /*插入STAGE/FLOW                         */
                                     /*插入STAGE/FLOW(調整項目2/3時使用)      */
sho10       varchar2(10),            /*员工编号                               */
                                     /*員工代號                               */
sho11       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
sho12       varchar2(1),             /*所插入的 Stage/Flow 是 Rework 工       */
                                     /*所插入的 Stage/Flow 是 Rework 製程     */
sho13       varchar2(1),             /*No Use                                 */
sho14       varchar2(1),             /*No Use                                 */
sho15       varchar2(1),             /*No Use                                 */
shouser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
shogrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
shomodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
shodate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
sho52       varchar2(1),             /*委外否                                 */
sho53       varchar2(1),             /*PQC 否                                 */
sho54       varchar2(1),             /*Check in 否                            */
shoplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sholegal    varchar2(10) NOT NULL,   /*所属法人                               */
shooriu     varchar2(10),            /*资料建立者                             */
shoorig     varchar2(10),            /*资料建立部门                           */
sho012      varchar2(10),            /*工艺段号                               */
sho16       number(9,4),             /*损耗率                                 */
sho17       number(9,4),             /*实际损耗率                             */
sho62       number(16,8),            /*单位用量                               */
sho63       number(16,8),            /*底数                                   */
sho64       number(9,4),             /*损耗批量                               */
sho112      varchar2(10)             /*来源工艺段号                           */
);

alter table sho_file add  constraint sho_pk primary key  (sho01) enable validate;
grant select on sho_file to tiptopgp;
grant update on sho_file to tiptopgp;
grant delete on sho_file to tiptopgp;
grant insert on sho_file to tiptopgp;
grant index on sho_file to public;
grant select on sho_file to ods;
