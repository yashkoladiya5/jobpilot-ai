// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:jobpilot_ai/core/di/register_module.dart' as _i301;
import 'package:jobpilot_ai/core/network/dio_client.dart' as _i107;
import 'package:jobpilot_ai/data/datasources/local/auth_local_datasource.dart'
    as _i73;
import 'package:jobpilot_ai/data/datasources/remote/auth_remote_datasource.dart'
    as _i1014;
import 'package:jobpilot_ai/data/datasources/remote/dashboard_remote_datasource.dart'
    as _i165;
import 'package:jobpilot_ai/data/datasources/remote/job_remote_datasource.dart'
    as _i173;
import 'package:jobpilot_ai/data/datasources/remote/resume_remote_datasource.dart'
    as _i696;
import 'package:jobpilot_ai/data/repositories/auth_repository_impl.dart'
    as _i70;
import 'package:jobpilot_ai/data/repositories/dashboard_repository_impl.dart'
    as _i363;
import 'package:jobpilot_ai/data/repositories/job_repository_impl.dart'
    as _i350;
import 'package:jobpilot_ai/data/repositories/resume_repository_impl.dart'
    as _i163;
import 'package:jobpilot_ai/domain/repositories/auth_repository.dart' as _i498;
import 'package:jobpilot_ai/domain/repositories/dashboard_repository.dart'
    as _i989;
import 'package:jobpilot_ai/domain/repositories/job_repository.dart' as _i92;
import 'package:jobpilot_ai/domain/repositories/resume_repository.dart'
    as _i621;
import 'package:jobpilot_ai/domain/usecases/auth/login_usecase.dart' as _i691;
import 'package:jobpilot_ai/domain/usecases/auth/logout_usecase.dart' as _i1;
import 'package:jobpilot_ai/domain/usecases/auth/register_usecase.dart'
    as _i599;
import 'package:jobpilot_ai/domain/usecases/dashboard/get_stats_usecase.dart'
    as _i517;
import 'package:jobpilot_ai/domain/usecases/job/create_job_usecase.dart'
    as _i612;
import 'package:jobpilot_ai/domain/usecases/job/delete_job_usecase.dart'
    as _i433;
import 'package:jobpilot_ai/domain/usecases/job/get_job_usecase.dart' as _i130;
import 'package:jobpilot_ai/domain/usecases/job/get_jobs_usecase.dart' as _i817;
import 'package:jobpilot_ai/domain/usecases/job/update_job_usecase.dart'
    as _i795;
import 'package:jobpilot_ai/domain/usecases/resume/delete_resume_usecase.dart'
    as _i344;
import 'package:jobpilot_ai/domain/usecases/resume/get_resumes_usecase.dart'
    as _i1051;
import 'package:jobpilot_ai/domain/usecases/resume/upload_resume_usecase.dart'
    as _i388;
import 'package:jobpilot_ai/presentation/bloc/auth/auth_bloc.dart' as _i653;
import 'package:jobpilot_ai/presentation/bloc/dashboard/dashboard_bloc.dart'
    as _i514;
import 'package:jobpilot_ai/presentation/bloc/job/job_bloc.dart' as _i365;
import 'package:jobpilot_ai/presentation/bloc/resume/resume_bloc.dart' as _i10;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i107.DioClient>(() => _i107.DioClient());
    gh.lazySingleton<_i165.DashboardRemoteDataSource>(
      () => _i165.DashboardRemoteDataSource(gh<_i107.DioClient>()),
    );
    gh.lazySingleton<_i173.JobRemoteDataSource>(
      () => _i173.JobRemoteDataSource(gh<_i107.DioClient>()),
    );
    gh.lazySingleton<_i696.ResumeRemoteDataSource>(
      () => _i696.ResumeRemoteDataSource(gh<_i107.DioClient>()),
    );
    gh.lazySingleton<_i1014.AuthRemoteDataSource>(
      () => _i1014.AuthRemoteDataSource(gh<_i107.DioClient>()),
    );
    gh.lazySingleton<_i989.DashboardRepository>(
      () =>
          _i363.DashboardRepositoryImpl(gh<_i165.DashboardRemoteDataSource>()),
    );
    gh.lazySingleton<_i73.AuthLocalDataSource>(
      () => _i73.AuthLocalDataSource(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i92.JobRepository>(
      () => _i350.JobRepositoryImpl(gh<_i173.JobRemoteDataSource>()),
    );
    gh.lazySingleton<_i621.ResumeRepository>(
      () => _i163.ResumeRepositoryImpl(gh<_i696.ResumeRemoteDataSource>()),
    );
    gh.factory<_i344.DeleteResumeUseCase>(
      () => _i344.DeleteResumeUseCase(gh<_i621.ResumeRepository>()),
    );
    gh.factory<_i388.UploadResumeUseCase>(
      () => _i388.UploadResumeUseCase(gh<_i621.ResumeRepository>()),
    );
    gh.factory<_i1051.GetResumesUseCase>(
      () => _i1051.GetResumesUseCase(gh<_i621.ResumeRepository>()),
    );
    gh.factory<_i795.UpdateJobUseCase>(
      () => _i795.UpdateJobUseCase(gh<_i92.JobRepository>()),
    );
    gh.factory<_i130.GetJobUseCase>(
      () => _i130.GetJobUseCase(gh<_i92.JobRepository>()),
    );
    gh.factory<_i612.CreateJobUseCase>(
      () => _i612.CreateJobUseCase(gh<_i92.JobRepository>()),
    );
    gh.factory<_i433.DeleteJobUseCase>(
      () => _i433.DeleteJobUseCase(gh<_i92.JobRepository>()),
    );
    gh.factory<_i817.GetJobsUseCase>(
      () => _i817.GetJobsUseCase(gh<_i92.JobRepository>()),
    );
    gh.factory<_i517.GetStatsUseCase>(
      () => _i517.GetStatsUseCase(gh<_i989.DashboardRepository>()),
    );
    gh.lazySingleton<_i498.AuthRepository>(
      () => _i70.AuthRepositoryImpl(
        gh<_i1014.AuthRemoteDataSource>(),
        gh<_i73.AuthLocalDataSource>(),
      ),
    );
    gh.factory<_i365.JobBloc>(
      () => _i365.JobBloc(
        getJobsUseCase: gh<_i817.GetJobsUseCase>(),
        getJobUseCase: gh<_i130.GetJobUseCase>(),
        createJobUseCase: gh<_i612.CreateJobUseCase>(),
        updateJobUseCase: gh<_i795.UpdateJobUseCase>(),
        deleteJobUseCase: gh<_i433.DeleteJobUseCase>(),
      ),
    );
    gh.factory<_i514.DashboardBloc>(
      () => _i514.DashboardBloc(getStatsUseCase: gh<_i517.GetStatsUseCase>()),
    );
    gh.factory<_i599.RegisterUseCase>(
      () => _i599.RegisterUseCase(gh<_i498.AuthRepository>()),
    );
    gh.factory<_i691.LoginUseCase>(
      () => _i691.LoginUseCase(gh<_i498.AuthRepository>()),
    );
    gh.factory<_i1.LogoutUseCase>(
      () => _i1.LogoutUseCase(gh<_i498.AuthRepository>()),
    );
    gh.factory<_i10.ResumeBloc>(
      () => _i10.ResumeBloc(
        gh<_i1051.GetResumesUseCase>(),
        gh<_i388.UploadResumeUseCase>(),
        gh<_i344.DeleteResumeUseCase>(),
      ),
    );
    gh.factory<_i653.AuthBloc>(
      () => _i653.AuthBloc(
        gh<_i691.LoginUseCase>(),
        gh<_i599.RegisterUseCase>(),
        gh<_i1.LogoutUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i301.RegisterModule {}
