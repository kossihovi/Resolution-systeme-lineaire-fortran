function bench(n) result(temp)
    use matutils
    use linearsolver
    implicit none
    
    !declarations
    type(MatrixSparse) :: A
    double precision, dimension(:), allocatable :: b, x
    double precision :: start, finish, temp 
    double precision, parameter :: epsilon=1.0d-7
    integer, intent(in) :: n 
    integer :: i, k, nnelmt
    integer, parameter :: kmax=1000

            
    !instruction
    nnelmt = 3*n - 2 !non null elements of matrix A
    allocate(A%nnz(n+1), A%val(nnelmt), A%icol(nnelmt))

    ! Construction of matrix
    A%nnz(1) = 0
    k = 0
    do i = 1, n
        if (i > 1) then
            k = k + 1
            A%icol(k) = i - 1
            A%val(k) = -1.0d0
        end if
            k = k + 1
            A%icol(k) = i
            A%val(k) = 4.0d0
        if (i < n) then
            k = k + 1
            A%icol(k) = i + 1
            A%val(k) = -1.0d0
        end if
            A%nnz(i+1) = k
    end do

    allocate(x(n), b(n))
    x = 1.0d0
    b = mat_vect(A, x)

    call cpu_time(start) !begining time
    !Resolution by Jacobi
    call jacobi(A, b, kmax, epsilon)
    call cpu_time(finish) ! end time

    !compute de time of resolution
    temp = finish-start

    deallocate(x, b, A%nnz, A%val, A%icol)

end function bench