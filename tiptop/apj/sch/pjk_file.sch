/*
================================================================================
檔案代號:pjk_file
檔案名稱:网络活动基本资料设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pjk_file
(
pjk01       varchar2(10) NOT NULL,   /*网络代号                               */
pjk02       varchar2(4) NOT NULL,    /*活动编号                               */
pjk03       varchar2(80),            /*活动名称                               */
pjk04       varchar2(4),             /*活动分类                               */
pjk05       varchar2(10),            /*部门编号                               */
pjk06       varchar2(1),             /*活动类型                               */
pjk07       varchar2(1),             /*进度审核方式                           */
pjk08       number(15,6),            /*审核完工率                             */
pjk09       varchar2(10),            /*计划poc方式                            */
pjk10       varchar2(10),            /*实际poc方式                            */
pjk11       varchar2(30),            /*对应wbs编号                            */
pjk12       number(15,3),            /*活动权重因数                           */
pjk13       varchar2(1),             /*优先工作否                             */
pjk14       number(15,3),            /*标准作业天数                           */
pjk15       number(15,3),            /*最少作业天数                           */
pjk16       date,                    /*预计开工日                             */
pjk17       date,                    /*预计完工日                             */
pjk18       date,                    /*实际开工日                             */
pjk19       date,                    /*实际完工日                             */
pjk20       date,                    /*推算最早开工日期                       */
pjk21       date,                    /*推算最早完工日期                       */
pjk22       date,                    /*推算最晚开工日期                       */
pjk23       date,                    /*推算最晚完工日期                       */
pjk24       number(15,3),            /*实际投入天数                           */
pjk25       varchar2(10),            /*工作负责人                             */
pjk26       varchar2(10),            /*负责部门                               */
pjk27       varchar2(1),             /*状态码                                 */
pjk28       date,                    /*实际进度跟新日期                       */
pjk29       varchar2(10),            /*实际进度跟新人员                       */
pjk30       date,                    /*推算进度跟新日期                       */
pjkacti     varchar2(1),             /*资料有效码                             */
pjkdate     date,                    /*最近更改日                             */
pjkgrup     varchar2(10),            /*资料所有部门                           */
pjkmodu     varchar2(10),            /*资料更改者                             */
pjkuser     varchar2(10),            /*资料所有者                             */
pjkoriu     varchar2(10),            /*资料建立者                             */
pjkorig     varchar2(10)             /*资料建立部门                           */
);

alter table pjk_file add  constraint pjk_pk primary key  (pjk01,pjk02) enable validate;
grant select on pjk_file to tiptopgp;
grant update on pjk_file to tiptopgp;
grant delete on pjk_file to tiptopgp;
grant insert on pjk_file to tiptopgp;
grant index on pjk_file to public;
grant select on pjk_file to ods;
