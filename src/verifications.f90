!gfortran -Wall -pedantic -o verifications matutils.f90 linearsolver.f90 verifications.f90
program verifications
    use matutils
    use linearsolver
    use benchmark
    implicit none

    !declarations
    type(MatrixSparse) :: A
    double precision, dimension(:), allocatable :: x, D, b
    double precision :: epsilon, a1, a2, a3, a4, s, temp  
    integer :: i, kmax, n, err, nnelmt, j, k


    !Instructions
    !call random_number(4)
    ! create and read the constant diagonals of matrix A from a file
    open(unit=2, file='lp.dat', status = 'replace')
    write(2, *) 4
    write(2, *) 1, 4, 2, 1
    write(2, *) 1, 0, -2, 1
    write(2, *) 1000
    write(2, *) 1.0d-7
    close(2)

    open(unit=2, file='lp.dat', status = 'old')
    read(2, *) n
    allocate(x(n), D(n), b(n))
    read(2, *) a1, a2, a3, a4
    read(2, *) b
    read(2, *) kmax
    read(2, *) epsilon
    close(2)


    !Test of convergence of Jacobi method
    s = abs(a1) + abs(a3) + abs(a4)  
    if (abs(a2) .LT. s) then
        print*, ' The matrix is not dominant diagonal'
    end if 

    if(n .LT. 1) then
        print*, " n must be positive "
       stop 
    end if
    
    nnelmt = 4*n - 4 !non null elements of matrix A
    ! Allocate tables of type matrixsparse
    if (.not.allocated(A%nnz)) then
        allocate(A%nnz(n+1), stat=err) ! allocate place in memory
        if (err /=0) then
            print*, "error in allocation of nnz table"
            stop
        end if 
    end if 
    if (.not.allocated(A%val)) then
        allocate(A%val(nnelmt), stat=err) ! allocate place in memory
        if (err /=0) then
            print*, "error in allocation of val table"
            stop
        end if 
    end if 

    if (.not.allocated(A%icol)) then
        allocate(A%icol(nnelmt), stat=err) ! allocate place in memory
        if (err /=0) then
            print*, "error in allocation of icol table"
            stop
        end if 
    end if 

    !compute Sparse matrix A
    A%nnz(1) = 0
    k = 0
    do i = 1, n
        do j = max(1, i-1), min(n, i+2) 
            k = k + 1
            A%icol(k) = j
            if(j .EQ. i - 1) then
                A%val(k) = a1
            else if (j .EQ. i) then
                A%val(k) = a2
            else if (j .EQ. i+1) then
                A%val(k) = a3
            else if (j .EQ. i+2) then
                A%val(k) = a4
            end if    
        end do
        A%nnz(i+1) = k
    end do


    !compute and print trace and norm of the matrix 
    call trace(A)
    call norme(A)

    !Resolve the Jacobi problem and save the solution in file "res.dat"
    call jacobi(A, b, kmax, epsilon)
    
    !compute time of resolution by Jacobi
    temp = bench(n)

    deallocate(A%nnz)
    deallocate(A%val)
    deallocate(A%icol)
    deallocate(x, D, b)


end program verifications

